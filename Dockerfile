FROM python:3.11-slim

WORKDIR /app
EXPOSE 3000

COPY requirements.txt ./
RUN pip install --upgrade --no-cache-dir pip \
    && pip install --no-cache-dir -r requirements.txt

COPY src ./

CMD ["uvicorn", "main:app", "--port", "3000", "--host", "0.0.0.0"]
