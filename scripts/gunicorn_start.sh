#!/usr/bin/env bash

NAME="ebdaemonlistener"     # Name of the application
PORT=80

# For performance tweaking, see: http://docs.gunicorn.org/en/stable/settings.html
NUM_WORKERS=3             # ~ 2 * CPUs + 1
NUM_THREADS=3             # ~ 2-4 * CPUs
WORKER_CLASS=sync
WORKER_CONNECTIONS=1000
BACKLOG=2048
MAX_REQUESTS=0
TIMEOUT=30
GRACEFUL_TIMEOUT=30
KEEPALIVE=2

# Prepare log files and start outputting logs to stdout
mkdir -p /var/app/logs
touch /var/app/logs/gunicorn.log
touch /var/app/logs/access.log
touch /var/app/logs/gunicorn_error.log
tail -n 0 -f /var/app/logs/*.log &

# Start your Flask Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
# The last line will allow you to pass additional arguments to gunicorn when you start the container
echo Starting Gunicorn.
exec gunicorn rest.wsgi \
  --name ${NAME} \
  --bind=0.0.0.0:${PORT} \
  --workers ${NUM_WORKERS} \
  --thread ${NUM_THREADS} \
  --worker-class=${WORKER_CLASS} \
  --worker-connections=${WORKER_CONNECTIONS} \
  --backlog=${BACKLOG} \
  --max-requests=${MAX_REQUESTS} \
  --timeout=${TIMEOUT} \
  --graceful-timeout=${GRACEFUL_TIMEOUT} \
  --keep-alive=${KEEPALIVE} \
  --pythonpath=/var/app \
  --proxy-allow-from='*' \
  --log-level=info \
  --log-file=/var/app/logs/gunicorn.log \
  --access-logfile=/var/app/logs/access.log \
  --error-logfile=/var/app/logs/gunicorn_error.log \
  "$@"
