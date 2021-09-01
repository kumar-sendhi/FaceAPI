from flask import Flask, render_template, url_for, jsonify, request
from flask.wrappers import Response
import person_group_operations
import uuid

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/persongroups/create', methods=['POST','GET'])
def create_person_group_route():
    if(request.method == 'POST'):
        data = {"name":request.form["name"]}
        res =  person_group_operations.create_person_group(str(uuid.uuid4()),data)
        print(res)
        return render_template("personGroupForm.html",message=res)
    else:
        return render_template("personGroupForm.html")
        
    

@app.route('/persongroups/get', methods=['GET'])
def get_person_group(persongroupid):
    data = request.get_json()
    # return person_group_operations.get_person_group(persongroupid)
    return render_template("personGroupCreate.html")

@app.route('/persongroups/<string:persongroupid>', methods=['PATCH'])
def update_person_group_route(persongroupid):
    data = request.get_json()
    return person_group_operations.update_person_group(persongroupid,request.get_json())


if __name__ == "__main__":
 app.run(host = "0.0.0.0", port = 8000)