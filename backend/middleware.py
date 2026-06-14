# ============================================================
# [Debugger/DevOps] Middleware & Error Handling
# ============================================================
# Logging, rate limiting, error interception, performance
# monitoring, and request validation for the API layer.

import time
import logging
import traceback
from functools import wraps
from typing import Callable, Any
from fastapi import Request, HTTPException
from fastapi.responses import JSONResponse
from collections import defaultdict
import threading

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("misinfoguard.middleware")


class RateLimiter:
    def __init__(self, max_requests: int = 60, window_seconds: int = 60):
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self._requests: dict[str, list[float]] = defaultdict(list)
        self._lock = threading.Lock()

    def check(self, client_id: str) -> bool:
        now = time.time()
        cutoff = now - self.window_seconds
        with self._lock:
            window = self._requests[client_id]
            window[:] = [t for t in window if t > cutoff]
            if len(window) >= self.max_requests:
                return False
            window.append(now)
            return True


rate_limiter = RateLimiter()


class PerformanceMonitor:
    def __init__(self):
        self._metrics: dict[str, list[float]] = defaultdict(list)
        self._lock = threading.Lock()

    def record(self, endpoint: str, duration_ms: float):
        with self._lock:
            self._metrics[endpoint].append(duration_ms)
            if len(self._metrics[endpoint]) > 1000:
                self._metrics[endpoint] = self._metrics[endpoint][-1000:]

    def get_stats(self) -> dict:
        with self._lock:
            stats = {}
            for endpoint, times in self._metrics.items():
                if times:
                    stats[endpoint] = {
                        "avg_ms": round(sum(times) / len(times), 2),
                        "min_ms": round(min(times), 2),
                        "max_ms": round(max(times), 2),
                        "p95_ms": round(sorted(times)[int(len(times) * 0.95)], 2),
                        "count": len(times),
                    }
            return stats


perf_monitor = PerformanceMonitor()


def timed_endpoint(endpoint_name: str) -> Callable:
    def decorator(func: Callable) -> Callable:
        @wraps(func)
        async def wrapper(*args, **kwargs):
            start = time.perf_counter()
            try:
                result = await func(*args, **kwargs)
                duration = (time.perf_counter() - start) * 1000
                perf_monitor.record(endpoint_name, duration)
                if duration > 1000:
                    logger.warning(
                        f"Slow endpoint [{endpoint_name}]: {duration:.1f}ms"
                    )
                return result
            except Exception as e:
                duration = (time.perf_counter() - start) * 1000
                logger.error(
                    f"Error in [{endpoint_name}] after {duration:.1f}ms: "
                    f"{type(e).__name__}: {e}"
                )
                raise
        return wrapper
    return decorator


async def global_error_handler(request: Request, exc: Exception) -> JSONResponse:
    error_id = f"ERR-{int(time.time())}"
    logger.error(
        f"[{error_id}] Unhandled error on {request.method} {request.url.path}: "
        f"{type(exc).__name__}: {exc}\n{traceback.format_exc()}"
    )
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "error_id": error_id,
            "message": str(exc) if isinstance(exc, HTTPException) else "An unexpected error occurred",
        },
    )


def validate_request_size(max_mb: int = 10):
    async def middleware(request: Request, call_next):
        content_length = request.headers.get("content-length")
        if content_length and int(content_length) > max_mb * 1024 * 1024:
            return JSONResponse(
                status_code=413,
                content={"error": f"Request too large. Maximum: {max_mb}MB"},
            )
        return await call_next(request)
    return middleware


def log_request_middleware():
    async def middleware(request: Request, call_next):
        start = time.perf_counter()
        response = await call_next(request)
        duration = (time.perf_counter() - start) * 1000
        logger.info(
            f"{request.method} {request.url.path} -> {response.status_code} "
            f"({duration:.1f}ms)"
        )
        response.headers["X-Response-Time-Ms"] = str(round(duration, 1))
        return response
    return middleware


def validate_json_payload(model_class):
    def decorator(func: Callable) -> Callable:
        @wraps(func)
        async def wrapper(*args, **kwargs):
            for arg in args:
                if isinstance(arg, model_class):
                    return await func(*args, **kwargs)
            return await func(*args, **kwargs)
        return wrapper
    return decorator


logger.info("Middleware layer initialized")
