FROM python:3.9.25-alpine3.22
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["flask", "run", "-h", "0.0.0.0"]
