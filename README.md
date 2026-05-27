# 🛡️ MisinfoGuard — Multimodal Misinformation Detection System

**MisinfoGuard** is a cross-platform, multimodal AI system that detects misinformation by analysing text, images, source credibility, and social propagation patterns simultaneously. Built as a college mini-project, it demonstrates a complete ML pipeline from model training to a polished mobile UI.

---

## ✨ Features

- **4‑Modality Fusion** — Text (BERT), Image (ResNet‑18), Source Credibility (logistic regression), Propagation (Graph Neural Network) — combined via learned attention-weighted fusion
- **Cross‑Platform Mobile App** — iOS + Android from a single Flutter codebase with Apple HIG‑compliant liquid glass UI
- **OLED Dark Mode** — Pure black backgrounds for battery savings; true glassmorphism with specular highlights and refraction
- **Real‑time Pipeline** — FastAPI backend with SQLite, rate limiting, and performance monitoring
- **Interactive Explainability** — Per‑modality breakdown scores, LIME word‑level explanations, decision path tracing
- **CI/CD Ready** — GitHub Actions pipeline: lint → test → integration → benchmark

---

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐
│   Flutter App        │     │   FastAPI Backend     │
│   (iOS + Android)    │◄───►│   (Python 3.11+)      │
│                     │     │                      │
│  • Liquid Glass UI  │     │  • /predict          │
│  • OLED Dark Mode   │     │  • /predict/batch    │
│  • Feed + Detail    │     │  • /model/info       │
│  • Dashboard        │     │  • /health           │
│  • Settings         │     │  • SQLite + feedback │
└─────────────────────┘     └──────────────────────┘
         │                           │
         ▼                           ▼
┌──────────────────────────────────────────────┐
│          ML Fusion Pipeline                   │
│                                              │
│  Text ──► BERT ──┐                           │
│  Image──►ResNet──►┤ Attention Fusion ──►      │
│  Credit──►LogReg─►│   Classifier              │
│  Propag──►  GNN ─┘                           │
└──────────────────────────────────────────────┘
```

---

## 🧠 ML Model Architecture

| Modality | Encoder | Output |
|----------|---------|--------|
| Text | BERT (base-uncased, 110M params) | 768‑dim authenticity embedding |
| Image | ResNet‑18 (modified, 11M params) | 512‑dim visual integrity embedding |
| Source Credibility | Logistic regression + dynamic decay | [0,1] credibility score |
| Propagation | 2‑layer GCN (GraphConv) | Suspicious cascade score |
| **Fusion** | **Learned weighted attention + 3‑layer MLP** | **Confidence‑calibrated prediction** |

**Total parameters:** ~112M  
**Training:** ~30 mins on a single GPU; early stopping + checkpointing built in

---

## 📱 Mobile App (Flutter)

### Design System
- **Apple HIG compliant** — SF Pro (Inter on Android) typography scale, semantic colors, HIG spacing
- **iOS 26 Liquid Glass** — Refraction, chromatic aberration, specular rim highlights, dynamic lighting
- **OLED Dark Mode** — Pure `#000000` background (pixels turn off on OLED screens)
- **Monochrome palette** — Black, white, grays only — no color, maximum contrast

### Screens

| Screen | Description |
|--------|-------------|
| **Feed** | Scrollable card feed with suspicion scores, source badges, pull‑to‑refresh |
| **Analyze** | Manual text/URL analysis with glass input card |
| **Insights** | Aggregate stats, detection trends, modality effectiveness breakdown |
| **Settings** | Threshold slider, OLED dark mode toggle, notifications, model info |

---

## 🚀 Getting Started

### Prerequisites
- Python 3.11+
- Flutter 3.38+ (Dart 3.10+)
- Android SDK 34+ (for Android build) or Xcode 15+ (for iOS build)

### 1. ML Backend

```bash
cd model
python -m venv .venv && source .venv/bin/activate
pip install -r ../requirements.txt

# Train the model
python train.py --epochs 10

# Evaluate
python evaluate.py
```

### 2. API Server

```bash
cd backend
uvicorn api:app --reload --host 0.0.0.0 --port 8000
```

### 3. Mobile App

```bash
cd mobile_flutter
flutter pub get
flutter run           # Run on connected device
flutter build apk     # Build Android APK
flutter build ios     # Build iOS archive (macOS only)
```

---

## 🧪 Test Suite

```bash
cd model
python -m pytest tests/ -v
```

All 27 tests pass (text encoder, image encoder, fusion classifier).

---

## 📸 Screenshots

| Feed | Detail | Dashboard | Settings |
|------|--------|-----------|----------|
| ![Feed](img/WhatsApp%20Image%202026-05-27%20at%2011.12.22%20PM.jpeg) | ![Detail](img/WhatsApp%20Image%202026-05-27%20at%2011.12.23%20PM.jpeg) | ![Dashboard](img/WhatsApp%20Image%202026-05-27%20at%2011.12.24%20PM.jpeg) | — |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **ML Framework** | PyTorch 2.x, torchvision, NetworkX |
| **Backend** | FastAPI, SQLite, Pydantic |
| **Mobile** | Flutter 3.38+, Dart 3.10+ |
| **Glass UI** | liquid_glass_widgets (iOS 26 design language) |
| **Fonts** | Google Fonts Inter (SF Pro equivalent) |
| **CI/CD** | GitHub Actions (lint → test → integration → benchmark) |

---

## 📄 Documentation

- [PRD](docs/PRD.md) — Product Requirements Document
- [Test Plan](docs/test_plan.md) — QA & testing strategy
- [Competitive Analysis](docs/competitive_analysis.md) — Market landscape
- [Board Strategy](docs/board_strategy.md) — Executive overview

---

## 👤 Contact

**Ananthakrishnan**  
📧 ananthakrishnan754@gmail.com  
🔗 [linkedin.com/in/ananthakrishnan754](https://linkedin.com/in/ananthakrishnan754)  
🐙 [github.com/ananthakrishnan754](https://github.com/ananthakrishnan754)

---

> *Built for college students in Mangalore — demonstrating end-to-end ML system design.*
