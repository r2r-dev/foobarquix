from fastapi import APIRouter
from pydantic import PositiveInt

from app.models.match import MatchResponse, match

router = APIRouter()


@router.get("/{number}", response_model=MatchResponse)
async def check(number: PositiveInt):
    return match(number)
