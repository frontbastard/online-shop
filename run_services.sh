#!/bin/bash

RABBITMQ="rabbitmq"
REDIS="redis"
CELERY_WORKER="celery_worker"
CELERY_FLOWER="celery_flower"
STRIPE_LISTEN="stripe_listen"
DJANGO_SERVER="django_server"

start_services() {
    echo "Starting services..."

    # RabbitMQ
    docker run -d --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.13.1-management &
    echo $! > .pid_$RABBITMQ

    # Redis
    docker run -d --rm --name redis -p 6379:6379 redis:7.2.4 &
    echo $! > .pid_$REDIS

    # Celery Worker
    celery -A online_shop worker -l info &
    echo $! > .pid_$CELERY_WORKER

    # Celery Flower
    celery -A online_shop flower --basic-auth=LOGIN:PASS &
    echo $! > .pid_$CELERY_FLOWER

    # Stripe Listener
    stripe listen --forward-to 127.0.0.1:8000/payment/webhook/ &
    echo $! > .pid_$STRIPE_LISTEN

    # Django Server
    python manage.py runserver &
    echo $! > .pid_$DJANGO_SERVER

    echo "All services started!"
}

stop_services() {
    echo "Stopping services..."

    for SERVICE in $RABBITMQ $REDIS $CELERY_WORKER $CELERY_FLOWER $STRIPE_LISTEN $DJANGO_SERVER; do
        if [ -f .pid_$SERVICE ]; then
            kill $(cat .pid_$SERVICE) 2>/dev/null
            rm -f .pid_$SERVICE
            echo "$SERVICE stopped!"
        else
            echo "$SERVICE not running or PID file missing."
        fi
    done

    echo "All services stopped!"
}

# Entrypoint
case $1 in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        stop_services
        start_services
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
