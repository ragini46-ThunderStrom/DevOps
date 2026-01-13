FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install flask
CMD ["python3", "app.py"]
