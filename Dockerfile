FROM ubuntu:20.04

RUN apt update && apt install -y g++ curl

WORKDIR /app

COPY . /app/
RUN g++ -std=c++17 -o http_server http_server.cpp Func.cpp -lpthread
EXPOSE 8081
CMD ["./http_server"]

