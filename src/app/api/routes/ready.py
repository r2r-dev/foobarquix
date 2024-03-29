from fastapi import APIRouter

from app.models.ready import ReadyResponse

router = APIRouter()


@router.get("/ready", response_model=ReadyResponse)
async def readiness_check():
    return ReadyResponse(status="ok")
