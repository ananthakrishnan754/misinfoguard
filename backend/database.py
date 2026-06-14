# ============================================================
# [Software Eng] Database Layer
# ============================================================
# SQLite-based storage for predictions, user feedback,
# credibility scores, and model audit logs.

import sqlite3
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional
import threading


class Database:
    def __init__(self, db_path: str = "misinfoguard.db"):
        self.db_path = Path(db_path)
        self._local = threading.local()
        self._init_db()

    def _get_conn(self) -> sqlite3.Connection:
        if not hasattr(self._local, "conn") or self._local.conn is None:
            self._local.conn = sqlite3.connect(str(self.db_path))
            self._local.conn.row_factory = sqlite3.Row
            self._local.conn.execute("PRAGMA journal_mode=WAL")
            self._local.conn.execute("PRAGMA foreign_keys=ON")
        return self._local.conn

    def _init_db(self):
        conn = self._get_conn()
        conn.executescript("""
            CREATE TABLE IF NOT EXISTS predictions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                text TEXT NOT NULL,
                image_path TEXT,
                prediction INTEGER NOT NULL,
                confidence REAL NOT NULL,
                suspicion_score REAL NOT NULL,
                modality_breakdown TEXT,
                model_version TEXT DEFAULT '1.0.0',
                created_at TEXT NOT NULL DEFAULT (datetime('now'))
            );

            CREATE TABLE IF NOT EXISTS feedback (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                prediction_id INTEGER NOT NULL,
                user_corrected_label INTEGER NOT NULL,
                feedback_type TEXT DEFAULT 'correction',
                created_at TEXT NOT NULL DEFAULT (datetime('now')),
                FOREIGN KEY (prediction_id) REFERENCES predictions(id)
            );

            CREATE TABLE IF NOT EXISTS credibility_scores (
                user_id TEXT PRIMARY KEY,
                score REAL NOT NULL DEFAULT 0.5,
                account_age_days INTEGER DEFAULT 0,
                flag_count INTEGER DEFAULT 0,
                report_accuracy_rate REAL DEFAULT 0.0,
                updated_at TEXT NOT NULL DEFAULT (datetime('now'))
            );

            CREATE TABLE IF NOT EXISTS propagation_graphs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                post_id TEXT NOT NULL,
                graph_json TEXT NOT NULL,
                num_nodes INTEGER DEFAULT 0,
                num_edges INTEGER DEFAULT 0,
                suspicious_nodes TEXT,
                created_at TEXT NOT NULL DEFAULT (datetime('now'))
            );

            CREATE INDEX IF NOT EXISTS idx_predictions_created
                ON predictions(created_at DESC);
            CREATE INDEX IF NOT EXISTS idx_feedback_prediction
                ON feedback(prediction_id);
        """)
        conn.commit()

    def log_prediction(
        self,
        text: str,
        prediction: int,
        confidence: float,
        suspicion_score: float,
        modality_breakdown: Optional[dict] = None,
        image_path: Optional[str] = None,
    ) -> int:
        conn = self._get_conn()
        cursor = conn.execute(
            """INSERT INTO predictions
               (text, image_path, prediction, confidence, suspicion_score, modality_breakdown)
               VALUES (?, ?, ?, ?, ?, ?)""",
            (
                text,
                image_path,
                prediction,
                confidence,
                suspicion_score,
                json.dumps(modality_breakdown) if modality_breakdown else None,
            ),
        )
        conn.commit()
        return cursor.lastrowid

    def log_feedback(self, prediction_id: int, corrected_label: int):
        conn = self._get_conn()
        conn.execute(
            "INSERT INTO feedback (prediction_id, user_corrected_label) VALUES (?, ?)",
            (prediction_id, corrected_label),
        )
        conn.commit()

    def update_credibility(
        self,
        user_id: str,
        score: float,
        account_age_days: int = 0,
        flag_count: int = 0,
        report_accuracy_rate: float = 0.0,
    ):
        conn = self._get_conn()
        conn.execute(
            """INSERT INTO credibility_scores
               (user_id, score, account_age_days, flag_count, report_accuracy_rate, updated_at)
               VALUES (?, ?, ?, ?, ?, datetime('now'))
               ON CONFLICT(user_id) DO UPDATE SET
               score = ?, account_age_days = ?, flag_count = ?,
               report_accuracy_rate = ?, updated_at = datetime('now')""",
            (user_id, score, account_age_days, flag_count, report_accuracy_rate,
             score, account_age_days, flag_count, report_accuracy_rate),
        )
        conn.commit()

    def get_recent_predictions(self, limit: int = 50) -> list[dict]:
        conn = self._get_conn()
        rows = conn.execute(
            "SELECT * FROM predictions ORDER BY created_at DESC LIMIT ?",
            (limit,),
        ).fetchall()
        return [dict(row) for row in rows]

    def get_feedback_stats(self) -> dict:
        conn = self._get_conn()
        total = conn.execute("SELECT COUNT(*) FROM feedback").fetchone()[0]
        if total == 0:
            return {"total": 0, "agreement_rate": 0.0}

        agreements = conn.execute(
            """SELECT COUNT(*) FROM feedback f
               JOIN predictions p ON f.prediction_id = p.id
               WHERE f.user_corrected_label = p.prediction""",
        ).fetchone()[0]

        return {
            "total": total,
            "agreement_rate": round(agreements / total, 4),
        }

    def get_dashboard_stats(self) -> dict:
        conn = self._get_conn()
        total_preds = conn.execute("SELECT COUNT(*) FROM predictions").fetchone()[0]
        misinfo_count = conn.execute(
            "SELECT COUNT(*) FROM predictions WHERE prediction = 1"
        ).fetchone()[0]
        avg_confidence = conn.execute(
            "SELECT AVG(confidence) FROM predictions"
        ).fetchone()[0] or 0.0

        return {
            "total_predictions": total_preds,
            "misinformation_count": misinfo_count,
            "misinformation_rate": round(misinfo_count / max(total_preds, 1), 4),
            "avg_confidence": round(avg_confidence, 4),
        }
