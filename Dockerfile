FROM openjdk:11-jre-slim
WORKDIR /backend
RUN ./gradlew build
WORKDIR /build/libs
COPY {빌드된 jar 파일이름} ./
CMD nohup java -jar {빌드된 jar 파일이름} & #jar파일 백그라운드 실행
EXPOSE 8080
