# Use an official lightweight Python image.
FROM python:3.9.7-slim

# Install pipenv
RUN pip install -U pip && \
    pip install pipenv

# Set working directory
WORKDIR /app

# Environment variable ensures that the python and pip executables used
# in the image will be those from our virtualenv.
ENV PIPENV_VENV_IN_PROJECT=true

# Copy Pipfile & Pipfile.lock first to leverage Docker cache
COPY [ "Pipfile", "./" ]

# Install all the dependencies
RUN pipenv install --deploy

# Copy rest of the application to WORKDIR
COPY [ "spotify_predict.py", "preprocessor.b", "./"]

# Expose the application's port
EXPOSE 8080

# Use pipenv to run the application
ENTRYPOINT [ "pipenv", "run", "gunicorn", "--bind=0.0.0.0:8080", "spotify_predict:app" ]
