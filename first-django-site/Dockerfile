# Use an official Python image
FROM python:3.12-slim

# Set the container working directory
WORKDIR /app

# Copy the dependency file
COPY requirements.txt /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project files
COPY  first-django-site /app/

# Allow Django to listen on port 8000
EXPOSE 8000

# Start the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]