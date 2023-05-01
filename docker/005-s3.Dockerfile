FROM ubuntu:latest

# Updating the system 
RUN apt update -y

# Arguments or variables
ARG port=80
ARG user=jenkins
ARG group=sysdamin

RUN apt install -y wget \
    unzip \
    tree \
    curl \
    git \
    vim 
RUN useradd ${user}
RUN groupadd ${group}
RUN usermod -aG ${group} ${user}
RUN echo 'jenkins:12345' | chpasswd

WORKDIR /var/www/html/
RUN rm -rf *


RUN wget https://linux-devops-course.s3.amazonaws.com/covid19.zip && \
    unzip covid19.zip && \
    rm -rf covid19.zip

RUN wget https://linux-devops-course.s3.amazonaws.com/creative.zip && \
    unzip creative.zip && \
    rm -rf creative.zip

RUN wget https://linux-devops-course.s3.amazonaws.com/halloween.zip && \
    unzip halloween.zip && \
    rm -rf halloween.zip

RUN wget https://linux-devops-course.s3.amazonaws.com/static-website-example.zip && \
    unzip static-website-example.zip && \
    rm -rf static-website-example.zip

RUN wget https://linux-devops-course.s3.amazonaws.com/website.zip && \
    unzip website.zip && \
    rm -rf website.zip

RUN wget https://linux-devops-course.s3.amazonaws.com/articles.zip && \
    unzip articles.zip && \
    rm -rf articles.zip && \
    cp -r articles/* .

RUN apt-get install apache2 -y
EXPOSE ${port}
CMD ["apachectl", "-D", "FOREGROUND"]


