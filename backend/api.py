# ============================================================
# [Software Eng] FastAPI Backend Service
# ============================================================
# REST API for MisinfoGuard prediction, training, and management.

import json
import torch
import numpy as np
from pathlib import Path
from typing import Optional
from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(
    title="MisinfoGuard API",
    version="1.0.0",
    docs_url="/docs",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MODEL_DIR = Path(__file__).parent.parent / "checkpoints"
MODEL_DIR.mkdir(exist_ok=True)


class PredictionInput(BaseModel):
    text: str
    image_path: Optional[str] = None
    user_data: dict = {}
    propagation_data: Optional[dict] = None


class PredictionOutput(BaseModel):
    is_misinformation: bool
    confidence: float
    suspicion_score: float
    modality_breakdown: dict
    explanation: dict


class BatchPredictionInput(BaseModel):
    items: list[PredictionInput]


class HealthResponse(BaseModel):
    status: str
    model_loaded: bool
    version: str


_model_pipeline = {"loaded": False}


def load_model_pipeline():
    if _model_pipeline["loaded"]:
        return

    try:
        from model.text_encoder import TextEncoder
        from model.image_encoder import ImageEncoder
        from model.credibility_scorer import CredibilityScorer
        from model.fusion_classifier import FusionClassifier

        text_encoder = TextEncoder(freeze_bert=True)
        image_encoder = ImageEncoder(freeze_backbone=True)
        credibility_scorer = CredibilityScorer()
        fusion = FusionClassifier()

        latest_ckpt = MODEL_DIR / "latest.pt"
        if latest_ckpt.exists():
            ckpt = torch.load(latest_ckpt, map_location="cpu", weights_only=True)
            fusion.load_state_dict(ckpt["fusion_state"])
            text_encoder.load_state_dict(ckpt["text_encoder_state"])
            image_encoder.load_state_dict(ckpt["image_encoder_state"])

        _model_pipeline.update({
            "text_encoder": text_encoder,
            "image_encoder": image_encoder,
            "credibility_scorer": credibility_scorer,
            "fusion": fusion,
            "loaded": True,
        })
    except Exception as e:
        raise RuntimeError(f"Failed to load model: {e}")


def get_pipeline():
    if not _model_pipeline["loaded"]:
        load_model_pipeline()
    return (
        _model_pipeline["text_encoder"],
        _model_pipeline["image_encoder"],
        _model_pipeline["credibility_scorer"],
        _model_pipeline["fusion"],
    )


@app.on_event("startup")
async def startup():
    try:
        load_model_pipeline()
    except Exception as e:
        print(f"Model loading deferred: {e}")


@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(
        status="ok",
        model_loaded=_model_pipeline["loaded"],
        version="1.0.0",
    )


@app.post("/predict", response_model=PredictionOutput)
async def predict(input: PredictionInput):
    te, ie, cs, fusion = get_pipeline()

    device = "cpu"
    te.to(device)
    ie.to(device)
    fusion.to(device)

    te.eval()
    ie.eval()
    fusion.eval()

    with torch.no_grad():
        text_logits, text_embed = te([input.text], return_embedding=True)

        if input.image_path and Path(input.image_path).exists():
            import cv2
            img = cv2.imread(input.image_path)
            img_tensor = ie.preprocess_opencv(img).to(device)
            image_logits, image_embed = ie(img_tensor, return_embedding=True)
        else:
            image_embed = torch.zeros(1, 64, device=device)

        if input.user_data:
            cred_feats = cs.extract_features(input.user_data)
            cred_tensor = torch.tensor(cred_feats, dtype=torch.float32, device=device)
        else:
            cred_tensor = torch.zeros(1, 8, device=device)

        prop_embed = torch.zeros(1, 16, device=device)
        if input.propagation_data:
            from model.propagation_gnn import PropagationGraphBuilder
            builder = PropagationGraphBuilder()
            builder.build_from_shares(
                users=input.propagation_data.get("users", []),
                shares=input.propagation_data.get("shares", []),
            )
            feat_matrix = builder.extract_node_features()
            if len(feat_matrix) > 0:
                prop_embed = torch.tensor(
                    feat_matrix.mean(axis=0, keepdims=True)[:, :16],
                    dtype=torch.float32,
                    device=device,
                )

        logits, confidence, attn_weights = fusion(
            text_embed, image_embed, cred_tensor, prop_embed,
            return_attention=True,
        )
        proba = torch.softmax(logits, dim=-1)
        pred = torch.argmax(proba, dim=-1).item()
        conf = confidence.item()
        suspicion = float(proba[0, 1]) if pred == 1 else float(proba[0, 0])

        modality_weights = fusion.get_modality_importance()
        modality_breakdown = {
            "text_score": float(text_logits.softmax(dim=-1)[0, 1].item()),
            "credibility_score": float(cred_tensor.mean().item()),
            "modality_importance": modality_weights,
            "attention_distribution": attn_weights[0].tolist(),
        }

    return PredictionOutput(
        is_misinformation=bool(pred),
        confidence=conf,
        suspicion_score=suspicion,
        modality_breakdown=modality_breakdown,
        explanation={
            "text_analysis": "Text analysis completed",
            "image_analysis": "No image" if not input.image_path else "Image analyzed",
            "credibility": "Source not evaluated" if not input.user_data else "Source scored",
            "propagation": "Not analyzed" if not input.propagation_data else "Propagation modeled",
        },
    )


@app.post("/predict/batch")
async def predict_batch(input: BatchPredictionInput):
    results = []
    for item in input.items:
        result = await predict(item)
        results.append(result)
    return {"results": results, "count": len(results)}


@app.get("/model/info")
async def model_info():
    te, ie, cs, fusion = get_pipeline()
    return {
        "modality_importance": fusion.get_modality_importance(),
        "text_encoder_params": sum(p.numel() for p in te.parameters()),
        "image_encoder_params": sum(p.numel() for p in ie.parameters()),
        "fusion_params": sum(p.numel() for p in fusion.parameters()),
        "text_encoder_frozen": te.freeze_bert,
        "device": "cpu",
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
