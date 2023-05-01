FROM ubuntu:latest

# Updating the system 
RUN apt update -y

# Installing packages
ARG port=80
ARG user=jenkins
ARG group=sysdamin

RUN apt install -y wget \
    unzip \
    tree \
    curl \
    git \
    vim 

WORKDIR /var/www/html/

RUN useradd ${user}
RUN groupadd ${group}
RUN usermod -aG ${group} ${user}
RUN echo 'jenkins:12345' | chpasswd

RUN rm -rf * && \
    wget https://linux-devops-course.s3.amazonaws.com/WEB+SIDE+HTML/covid19.zip && \
    unzip covid19.zip && \
    cp -r covid19/* . && \
    rm -rf covid19.zip && \
    rm -rf covid19

RUN apt-get install apache2 -y
EXPOSE ${port}
CMD ["apachectl", "-D", "FOREGROUND"]


