FROM ubuntu:20.04 as builder

RUN apt update && apt install -y g++ curl

WORKDIR /app
RUN curl -L -o http_server.cpp https://raw.githubusercontent.com/LafRina/DevOpsLaba3/branchHTTPserver/http_server.cpp
RUN curl -L -o Func.cpp https://raw.githubusercontent.com/LafRina/DevOpsLaba3/branchHTTPserver/Func.cpp
RUN curl -L -o Func.h https://raw.githubusercontent.com/LafRina/DevOpsLaba3/branchHTTPserver/Func.h 

RUN g++ -std=c++17 -o http_server http_server.cpp Func.cpp -lpthread
FROM alpine:3.18

WORKDIR /app
COPY . /app/
EXPOSE 8081
CMD ["./http_server"]

