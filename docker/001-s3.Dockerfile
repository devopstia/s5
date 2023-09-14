FROM ubuntu:latest

# Updating the system 
RUN apt update -y

# Installing packages
RUN apt install -y wget \
    unzip \
    tree \
    curl \
    git \
    vim 

WORKDIR /var/www/html/
RUN rm -rf * 
RUN wget https://linux-devops-course.s3.amazonaws.com/WEB+SIDE+HTML/covid19.zip
RUN unzip covid19.zip
RUN cp -r covid19/* .
RUN rm -rf covid19.zip
RUN rm -rf covid19

RUN apt-get install apache2 -y
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]

