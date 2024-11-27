# Stage 1: Build environment
FROM python:3.10-slim as builder

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install Python dependencies in a separate layer
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime environment
FROM python:3.10-slim as runtime

# Copy the installed dependencies from the builder image
COPY --from=builder /usr/local /usr/local

# Set the working directory
WORKDIR /app

# Copy the rest of the application files
COPY . .

# Expose the application port
EXPOSE 5000

# Command to run the Flask application directly with Python
CMD ["python", "app.py"]

