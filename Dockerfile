# Dockerfile
FROM python:3.11-slim

# متغیرهای محیطی
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# نصب وابستگی‌های سیستم
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# کپی و نصب پکیج‌ها
COPY AI_talk/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# کپی کامل پروژه
COPY AI_talk /app

# لیبل‌ها برای داکرهاب
LABEL maintainer="yhyaa.79"
LABEL description="AI Talk Flask App"

EXPOSE 8090

# Gunicorn برای production
CMD ["gunicorn", "--bind", "0.0.0.0:8090", \
     "--workers", "3", \
     "--worker-class", "sync", \
     "--timeout", "180", \
     "app:app"]