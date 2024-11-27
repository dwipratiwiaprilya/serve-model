FROM python:3.10-slim as builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.10-slim as runtime

COPY --from=builder /usr/local /usr/local

WORKDIR /app

COPY . .

EXPOSE 8080
ENV PORT

CMD ["python", "app.py"]

