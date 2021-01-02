from fastapi.testclient import TestClient

from app.asgi import get_application

app = get_application()

client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 404
    assert response.json() == {"detail": "Not Found"}


def test_ready():
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_num():
    response = client.get("/33")
    assert response.status_code == 200
    assert response.json() == {"result": "FooFooFoo"}
