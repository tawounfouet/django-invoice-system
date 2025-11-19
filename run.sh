#!/bin/bash
set -e

# Set production environment
export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-django_invoice.settings}
cat << EOF
  _____ _____.__ .__ 
_/ __ \ __\   __\| |/ ___\\__ \ | | / ___/
\ ___/| | | | | \ \ \ ___ / __ \| |__\___ \
\___ >__| |__| |__|\___ >____ /____/____ >
\/ \/ \/ \/ \/
EOF

echo "Running the project"
echo "Installing requirements..."
pip install -r requirements.txt

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "** Number of workers ${GUNICORN_WORKERS:-4}"
echo "** Starting gunicorn..."

# Starting Gunicorn 
gunicorn django_invoice.wsgi:application --bind 0.0.0.0:8000 --workers "${GUNICORN_WORKERS:-4}" --log-level INFO --timeout=120 --keep-alive=5
