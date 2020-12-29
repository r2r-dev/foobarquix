from fastapi import APIRouter

from app.api.routes import match
from app.api.routes import ready

router = APIRouter()

router.include_router(ready.router, tags=["ready"])
router.include_router(match.router, tags=["match"])
