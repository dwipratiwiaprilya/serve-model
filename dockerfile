# Stage 1: Build environment
FROM python:3.12-slim as builder

# Install necessary build tools (including distutils)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install Python dependencies in a separate layer
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Runtime environment
FROM python:3.12-slim as runtime

# Copy the installed dependencies from the builder image
COPY --from=builder /install /usr/local

# Set the working directory
WORKDIR /app

# Copy the rest of the application files
COPY . .

# Expose the application port
EXPOSE 5000

# Command to run the application with Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

