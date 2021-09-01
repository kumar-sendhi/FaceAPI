FROM python:3.9.1
copy . /app
WORKDIR /app/FaceAPI/
RUN pip install -r requirements.txt
CMD ["python3","app.py"]
