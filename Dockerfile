# Python 이미지를 기반으로 합니다.
FROM python:3.8-slim-buster

# 작업 디렉터리를 설정합니다.
WORKDIR /app

# 필요한 패키지를 설치합니다.
RUN python -m venv venv
RUN /bin/bash -c "source venv/bin/activate"
RUN pip install --upgrade pip
RUN pip install flask flask-migrate flask-wtf

# 애플리케이션 코드를 복사합니다.
COPY . .

# 환경 변수를 설정합니다.
ENV FLASK_APP=shop
ENV FLASK_DEBUG=true

# Flask 서비스를 실행합니다.
CMD ["flask", "db", "init"]
CMD ["flask", "db", "migrate"]
CMD ["flask", "db", "upgrade"]
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]

# 서비스 포트를 노출합니다.
EXPOSE 8080
