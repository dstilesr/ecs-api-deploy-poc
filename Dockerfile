FROM python:3.11-slim

WORKDIR /app
EXPOSE 80

COPY requirements.txt ./
RUN pip install --upgrade --no-cache-dir pip \
    && pip install --no-cache-dir -r requirements.txt

COPY src ./

CMD ["uvicorn", "main:app", "--port", "80", "--host", "0.0.0.0"]
