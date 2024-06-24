#!/bin/sh

echo "Waiting for postgres to start..."

while ! nc -z db 5432; do
  sleep 0.1
done

echo "PostgreSQL started"

echo "Applying db migrations"
python manage.py makemigrations
python manage.py migrate

echo "Collecting static"
python manage.py collectstatic --no-input
chmod 755 -R /app/web/staticfiles

echo "Create superuser"
python manage.py shell -c "
from django.contrib.auth.models import User
User.objects.create_superuser('admin', 'admin@example.com', 'admin')
"

exec "$@"
