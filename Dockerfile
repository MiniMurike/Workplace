FROM python:3.11.4-slim-buster

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update && \
    apt-get install -y netcat && \
    apt-get install -y --no-install-recommends gcc && \
    apt-get install -y gunicorn

COPY . .

# install dependencies
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

# copy ep.sh
COPY ./ep.sh /app/
RUN sed -i 's/\r$//g' /app/ep.sh
RUN chmod +x /app/ep.sh

# run ep.sh
ENTRYPOINT ["./ep.sh"]
