FROM python:3.6.8-stretch

ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=0.12.16

RUN pip install "poetry==$POETRY_VERSION"

WORKDIR /var/app

# Copy only requirements to cache them in docker layer
COPY poetry.lock pyproject.toml /var/app/

RUN poetry config settings.virtualenvs.create false \
  && poetry install --no-interaction --no-ansi

# Gunicorn
RUN pip install gunicorn setproctitle
COPY ./scripts/gunicorn_start.sh /var/app/gunicorn_start.sh
RUN chmod u+x /var/app/gunicorn_start.sh

# Copy the app's files
COPY . /var/app

# Add app to Python path
ENV PYTHONPATH="${PYTHONPATH}:/var/app"

# Create log directories
RUN mkdir -p /var/app/logs

# Open port
EXPOSE 80

ENTRYPOINT ["/var/app/gunicorn_start.sh"]
