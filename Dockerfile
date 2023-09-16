FROM python:3.10-slim as builder
WORKDIR /usr/src/app
RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt > requirements.txt

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.10

# pythonライブラリをインストール
COPY --from=builder /usr/src/app/requirements.txt .
RUN pip install --upgrade pip &&\
  pip install -r requirements.txt --no-deps &&\
  rm -rf ~/.cache/pip

ENV API_ENV dev
WORKDIR /
COPY ./app /app/

RUN curl -sSL https://install.python-poetry.org | python -
ENV PATH /root/.local/share/pypoetry/venv/bin:$PATH

RUN pip install uvicorn
RUN pip install pytest
RUN pip install fastapi uvicorn[standard]

RUN pip install flask
RUN pip install line-bot-sdk
RUN pip install requests
RUN pip install pillow
RUN pip install psycopg2

RUN pip install langchain
RUN pip install geopy
RUN pip install openai

RUN pip install google
RUN pip install --upgrade google-api-python-client
RUN pip install --upgrade google-cloud-storage
COPY credential.json /work/credential.json

CMD uvicorn app.main:app --host 0.0.0.0 --port 8080
