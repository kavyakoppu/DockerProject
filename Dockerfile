FROM tiangolo/uwsgi-nginx-flask:python3.7
COPY ./docker /app
CMD ["python", "app.py"]

