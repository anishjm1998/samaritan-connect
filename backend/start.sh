#!/bin/sh
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser --noinput || echo "Superuser already exists, skipping creation."

echo "ENV : $ENV" 

if [ "$ENV" = "prod" ]; then
    echo "Starting production server..."
    exec gunicorn --workers ${GUNICORN_WORKERS} --bind "0.0.0.0:${API_PORT}" djangotango.asgi:application -k uvicorn.workers.UvicornWorker
else
    echo "Starting development server..."
    python manage.py runserver 0.0.0.0:${API_PORT}
fi