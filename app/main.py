import os
from flask import Flask, jsonify, Response


app = Flask(__name__)

@app.route("/status")
def status():
    return jsonify({"status": "ok"})

@app.route("/")
def root():
    return "CloudFit API running"

@app.route('/favicon.ico')
def favicon():
    # 204 No Content: não tem ícone, mas não dá erro
    return Response(status=204)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
