FROM ubuntu:latest

LABEL maintainer="devopseasylearning.com"
LABEL build_date="2017-09-05"

ENV DB_USENAME admin
ENV DB_PASSWORD 12345

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

VOLUME /s5student2
VOLUME /s5student1
COPY . /s5student1  
ADD . /s5student2 

WORKDIR /var/www/html/
RUN rm -rf *

ADD https://linux-devops-course.s3.amazonaws.com/covid19.zip /var/www/html/
RUN unzip covid19.zip
RUN rm -rf covid19.zip

ADD https://linux-devops-course.s3.amazonaws.com/creative.zip /var/www/html/
RUN unzip creative.zip 
RUN rm -rf creative.zip

ADD https://linux-devops-course.s3.amazonaws.com/halloween.zip /var/www/html/
RUN unzip halloween.zip 
RUN rm -rf halloween.zip

ADD https://linux-devops-course.s3.amazonaws.com/static-website-example.zip /var/www/html/
RUN unzip static-website-example.zip 
RUN rm -rf static-website-example.zip

ADD https://linux-devops-course.s3.amazonaws.com/website.zip /var/www/html/
RUN unzip website.zip 
RUN rm -rf website.zip

ADD https://linux-devops-course.s3.amazonaws.com/articles.zip /var/www/html/
RUN unzip articles.zip 
RUN rm -rf articles.zip 
RUN cp -r articles/* .

RUN apt-get install apache2 -y
EXPOSE ${port}
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]
