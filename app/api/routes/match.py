from fastapi import APIRouter

from app.models.match import MatchRequest
from app.models.match import MatchResponse

router = APIRouter()

# TODO: route
# TODO: tests
@router.get("/{number}", response_model=MatchResponse)
async def check(number: int):
  # TODO: err handling
  # TODO: service
  return MatchRequest().match(number)

