FROM python:3.12.11

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y git

RUN mkdir /polarag_backend
WORKDIR /polarag_backend
RUN python3 -m pip install --upgrade pip setuptools

EXPOSE 8000
