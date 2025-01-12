# Online Shop
- `docker pull rabbitmq:3.13.1-management`


- `docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.13.1-management`
- `docker run -it --rm --name redis -p 6379:6379 redis:7.2.4`
- `celery -A online_shop worker -l info`
- `celery -A online_shop flower --basic-auth=LOGIN:PASS`


- `python manage.py runserver`


- `http://127.0.0.1:8000/`
- `http://127.0.0.1:15672/` # guest:guest
- `http://127.0.0.1:5555/` # LOGIN:PASS

