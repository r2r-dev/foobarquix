from pydantic import BaseModel


class MatchResponse(BaseModel):
    result: str

class MatchRequest:
    match_verbs = (
      (3,"Foo"),
      (5,"Bar"),
      (7,"Qix")
    )
    match_map = lambda matchf, numbers, verbs: [
      verb[1]
      for verb in verbs
      for number in numbers
      if matchf(number, verb[0])
    ]

    def match(self, number):
      divisible_matches = MatchRequest.match_map(
        matchf = lambda number, match_verb: number > 0 and number % match_verb == 0,
        numbers = [number],
        verbs = MatchRequest.match_verbs
      )
      existence_matches = MatchRequest.match_map(
        matchf = lambda number, match_verb: number == match_verb,
        numbers = [int(x) for x in str(number)],
        verbs = MatchRequest.match_verbs
      )

      matches = divisible_matches + existence_matches

      if (len(matches) == 0): result = str(number)
      else: result = "".join(matches)
      return MatchResponse(result = result)

