import json

from fastapi.testclient import TestClient
from parametrized import parametrized

from app.asgi import get_application

app = get_application()

client = TestClient(app)

number_not_positive_response_body = {
    "detail": [
        {
            "ctx": {"limit_value": 0},
            "loc": ["path", "number"],
            "msg": "ensure this value is greater than 0",
            "type": "value_error.number.not_gt",
        },
    ],
}

number_not_int_response_body = {
    "detail": [
        {
            "loc": ["path", "number"],
            "msg": "value is not a valid integer",
            "type": "type_error.integer",
        },
    ],
}

with open("tests/data/test_data.json") as json_file:
    test_input = json.load(json_file)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200


def test_ready():
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_read_not_found():
    response = client.get("/some/path")
    assert response.status_code == 404


@parametrized.zip
def test_valid_num_response(
    test_request=test_input["requests"],
    expected_response=test_input["responses"],
):
    response = client.get("/{num}".format(num=test_request))
    assert response.status_code == expected_response["code"]
    assert response.json() == expected_response["body"]


def test_num_match():
    response = client.get("/33")
    assert response.status_code == 200
    assert response.json() == {"result": "FooFooFoo"}


def test_num_no_match():
    response = client.get("/88")
    assert response.status_code == 200
    assert response.json() == {"result": "88"}


def test_num_exception_on_negative_number():
    response = client.get("/-1")
    assert response.status_code == 422
    assert response.json() == number_not_positive_response_body


def test_num_exception_on_zero():
    response = client.get("/0")
    assert response.status_code == 422
    assert response.json() == number_not_positive_response_body


def test_num_exception_on_non_int_arguments():
    response = client.get("/invalidnonint")
    assert response.status_code == 422
    assert response.json() == number_not_int_response_body

    response = client.get("/0.1")
    assert response.status_code == 422
    assert response.json() == number_not_int_response_body
