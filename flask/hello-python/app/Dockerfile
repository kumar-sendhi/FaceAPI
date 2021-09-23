FROM sconecuratedimages/kubernetes:python-3.7.3-alpine3.10-scone4.2
#FROM python:3.7

RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN pip install -r requirements.txt

EXPOSE 5000
CMD ["python3", "/app/main.py"]