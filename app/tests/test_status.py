import json
from app import app

def test_status_route():
    client = app.test_client()
    resp = client.get("/status")
    assert resp.status_code == 200
    data = json.loads(resp.data.decode("utf-8"))
    assert data == {"status": "ok"}
