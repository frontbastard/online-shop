# Online Shop
## Prereqs:
- Docker is installed and running

## Run the project
Allow the run_services.sh execution `chmod +x run_services.sh`

### Commands for managing the project
- `./run_services.sh start`
- `./run_services.sh stop`
- `./run_services.sh restart`
- `./run_services.sh kill`

### Or run these commands one by one:
- `docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.13.1-management`
- `docker run -it --rm --name redis -p 6379:6379 redis:7.2.4`
- `celery -A online_shop worker -l info`
- `celery -A online_shop flower --basic-auth=LOGIN:PASS`
- `stripe listen --forward-to 127.0.0.1:8000/payment/webhook/`
- `python manage.py runserver`

## Access links:
- Client `http://127.0.0.1:8000/`
- RabbitMQ `http://127.0.0.1:15672/` # guest:guest
- Flower `http://127.0.0.1:5555/` # LOGIN:PASS

