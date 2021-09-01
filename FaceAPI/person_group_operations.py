import os,requests

headers = {
    'Content-Type': 'application/json',
    'Ocp-Apim-Subscription-Key': os.environ.get("API_KEY"),
}

def create_person_group(personGroupId,request_body):
    constructed_url = os.environ.get("BASE_URL") + "/persongroups/" + personGroupId
    response = requests.put(constructed_url,headers=headers,json=request_body)
    if(response.content):
        print(response)
        print(response.status_code)
        return response.json()
    elif response.status_code == 200:
        return f"Person group with id {personGroupId} created"

def get_person_group(personGroupId):
    constructed_url = os.environ.get("BASE_URL") + "/persongroups/" + personGroupId
    response = requests.get(url=constructed_url,headers=headers)
    return response.json()

def update_person_group(personGroupId,request_body):
    constructed_url = os.environ.get("BASE_URL") + "/persongroups/" + personGroupId
    response = requests.patch(constructed_url,headers=headers,json=request_body)

    if(response.content):
        print(response)
        print(response.status_code)
        return response.json()
    elif response.status_code == 200:
        return f"Person group with id {personGroupId} updated"