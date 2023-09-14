FROM ubuntu:latest

RUN apt update -y
RUN apt install wget -y
RUN apt install unzip -y
RUN apt install tree -y
RUN apt install curl -y
RUN apt install git -y
RUN apt install  vim -y


RUN apt update -y && \
    apt install wget -y && \
    apt install unzip -y && \
    apt install tree -y && \
    apt install curl -y && \
    apt install git -y && \
    apt install  vim -y


