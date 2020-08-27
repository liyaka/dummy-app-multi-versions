FROM python:3.7

ADD app/* /app/
WORKDIR /app
RUN pip install -r requirements.txt
ADD version.txt /app/version.txt

EXPOSE 5000
CMD ["python", "/app/main.py"]
