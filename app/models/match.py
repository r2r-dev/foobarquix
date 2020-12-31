from pydantic import BaseModel

MATCH_VERBS = ((3, "Foo"), (5, "Bar"), (7, "Qix"))


class MatchResponse(BaseModel):
    result: str


def match_map(matchf, numbers, verbs):
    return [verb[1] for verb in verbs for number in numbers if matchf(number, verb[0])]


def match(number):
    divisible_matches = match_map(
        matchf=lambda number, match_verb: number > 0 and number % match_verb == 0,
        numbers=[number],
        verbs=MATCH_VERBS,
    )
    existence_matches = match_map(
        matchf=lambda number, match_verb: number == match_verb,
        numbers=[int(digit) for digit in str(number)],
        verbs=MATCH_VERBS,
    )

    matches = divisible_matches + existence_matches

    if matches:
        match_s = "".join(matches)
    else:
        match_s = str(number)
    return MatchResponse(result=match_s)
