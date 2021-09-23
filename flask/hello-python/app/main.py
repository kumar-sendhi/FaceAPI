from flask import Flask, render_template, url_for, jsonify, request, redirect
from flask.wrappers import Response
#import person_group_operations,person_operations,person_face_operations
import uuid
import os
app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
@app.route("/")
def index():
    return render_template("index.html")
    #value = os.getenv('Greeting')
    #return "Hello from Python!"+ ' '+value
    #return "Hello from Python!"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
