from fastapi import APIRouter

from app.models.match import MatchResponse, match

router = APIRouter()


@router.get("/{number}", response_model=MatchResponse)
async def check(number: int):
    return match(number)
