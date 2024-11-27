# Stage 1: Build environment
FROM python:3.12-slim AS builder

WORKDIR /app

# Install system dependencies required for Python libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies in a separate layer
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Runtime environment
FROM python:3.12-slim

WORKDIR /app

# Copy only the installed Python packages from the builder stage
COPY --from=builder /install /usr/local

# Copy the application files
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Use Gunicorn as the application server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

