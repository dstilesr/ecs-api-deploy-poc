FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app
EXPOSE 80

COPY pyproject.toml ./
COPY uv.lock ./
RUN uv sync --no-cache --no-dev

COPY src ./

CMD ["uv", "run", "--no-sync", "uvicorn", "main:app", "--port", "80", "--host", "0.0.0.0"]
