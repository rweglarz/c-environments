from datetime import datetime
from flask import Flask
from flask import jsonify
from flask import request
from waitress import serve

import os


app = Flask(__name__)
hostname = os.environ.get('hostname', 'nohostname')
server_ip = os.environ.get('server_ip', 'unknown')

@app.route('/')
def root():
    now = datetime.now().strftime("%H:%M:%S")
    s = f"<HTML>\n"
    s+= f"Hello, this is {hostname} serving from ip {server_ip}<BR>\n"
    s+= f"handling:{request.environ['HTTP_HOST']} your IP:{request.remote_addr}<BR>\n"
    s+= f"time now:{now}<BR>\n"
    s+= f"</HTML>\n"
    return s

@app.route('/api')
def api():
    now = datetime.now().strftime("%H:%M:%S")
    d = {
        "hostname": hostname,
        "server_ip": server_ip,
        "client_ip": request.remote_addr,
        "now": now,
    }
    return jsonify(d)

if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=80)
    #app.run(debug=False, host='0.0.0.0', port=8080)
