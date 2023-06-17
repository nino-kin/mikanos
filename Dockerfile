FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    git \
    bash
RUN pip install pre-commit

WORKDIR /app

CMD ["pre-commit", "run", "-a"]
