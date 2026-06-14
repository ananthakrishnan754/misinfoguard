# MisinfoGuard — Test Plan

## [Tester/QA]

---

### 1. Test Scope

| Module | Tests | Type |
|---|---|---|
| Text Encoder | Forward shape, embedding, proba, batch, edge cases | Unit |
| Image Encoder | Forward shape, preprocessing, batch, edge cases | Unit |
| Fusion Classifier | Forward, predict, gradient flow, modality importance | Unit |
| Propagation GNN | Graph builder, feature extraction, pattern detection | Unit |
| Credibility Scorer | Feature extraction, scoring, update | Unit |
| Training Pipeline | Epoch loop, validation, checkpointing | Integration |
| Evaluation | Metrics computation, ablation, benchmark | Integration |
| Backend API | Health, predict, batch predict, error handling | Integration |
| Database | CRUD, feedback logging, stats | Integration |

### 2. Test Data

| Dataset | Source | Size | Use |
|---|---|---|---|
| LIAR | Political statements | 12.8K | Text authenticity |
| FAKENEWSNET | News articles | 23.5K | Text classification |
| CASIA-WebFace | Face images | 500K | Image verification |
| Twitter15 | Propagation graphs | 1.5K | Graph patterns |
| Custom propagation | Synthetic graphs | 10K | GNN training |

### 3. Test Categories

#### Unit Tests (Priority: High)
- Run on every PR
- Coverage target: > 85%
- Max runtime: 30s

#### Integration Tests (Priority: High)
- Run nightly
- End-to-end pipeline
- Max runtime: 10min

#### Performance Tests (Priority: Medium)
- Inference latency benchmarks
- Memory profiling
- Throughput under load

#### Adversarial Tests (Priority: Low — v1.1)
- Text adversarial attacks (TextFooler)
- Image perturbation (FGSM)
- Graph poisoning

### 4. Test Execution

```bash
# Unit tests
python -m pytest model/tests/ -v

# Integration tests
python -m pytest tests/integration/ -v

# With coverage
python -m pytest model/tests/ --cov=model --cov-report=term-missing

# Performance benchmark
python model/evaluate.py --benchmark
```

### 5. Edge Cases to Validate

| Module | Edge Case | Expected Behavior |
|---|---|---|
| Text | Empty string | Returns valid logits |
| Text | 10K+ token input | Truncated to 512 tokens |
| Image | Grayscale input | Converted to RGB |
| Image | Corrupted image file | Graceful error |
| Fusion | All-zero embeddings | No NaN predictions |
| Fusion | Single sample | Valid singleton output |
| Credibility | Unknown user | Returns default 0.5 |
| Propagation | Empty graph | Returns zeros |
| API | Missing fields | 422 validation error |
| API | Oversized payload | 413 entity too large |

### 6. Pass/Fail Criteria

| Criterion | Threshold | Action |
|---|---|---|
| Unit test pass rate | 100% | Block PR |
| Code coverage | > 85% | Warning, no block |
| Inference latency (p95) | < 500ms | Performance review |
| Evaluation accuracy | > 85% | Retrain required |
| Memory usage | < 2GB | Optimization needed |

### 7. Tooling

- **Framework**: pytest
- **Coverage**: pytest-cov
- **Performance**: cProfile, PyTorch profiler
- **Adversarial**: advex-ai, textattack
- **CI**: GitHub Actions
