#! /bin/bash

function software_installation {
    sudo apt update -y
    sudo apt-get install -y curl 
    sudo apt-get install -y wget 
    sudo apt-get install -y vim 
    sudo apt-get install -y git 
    sudo apt-get install -y make 
    sudo apt-get install -y ansible 
    sudo apt-get install -y python3-pip 
    sudo apt-get install -y openssl 
    sudo apt-get install -y rsync 
    sudo apt-get install -y jq 
    sudo apt-get install -y postgresql-client 
    sudo apt-get install -y mariadb-client 
    sudo apt-get install -y mysql-client 
    sudo apt-get install -y unzip 
    sudo apt-get install -y tree 
}

function packages_installation {
    ## Install AWS CLI
    # https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version

    ## Install Packer
    # https://developer.hashicorp.com/packer/downloads
    sudo wget https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip -P /tmp
    sudo unzip /tmp/packer_1.7.4_linux_amd64.zip -d /usr/local/bin
    chmod +x /usr/local/bin/packer
    packer --version

    ## Install Docker
    # https://docs.docker.com/engine/install/ubuntu/
    sudo apt-get remove docker docker-engine docker.io containerd runc -y
    sudo apt-get update
    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl start docker
    sudo systemctl enable docker

    ## Install Docker Coompose
    # https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    ## Install Java 11
    # https://stackoverflow.com/questions/52504825/how-to-install-jdk-11-under-ubuntu
    sudo apt-get update
    sudo apt-get install openjdk-11-jdk -y 
    java --version
    sudo update-java-alternatives --list
    # sudo update-alternatives --config java

    ## Install Terraform
    # https://releases.hashicorp.com/terraform/
    TERRAFORM_VERSION="1.2.6"
    sudo wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo mv terraform /usr/local/bin/terraform
    sudo rm -f terraform terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    terraform --version

    ### TERRAGRUNT INSTALLATIN
    # https://terragrunt.gruntwork.io/docs/getting-started/supported-terraform-versions/
    TERRAGRUNT_VERSION="v0.38.0"
    sudo wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 
    sudo mv terragrunt_linux_amd64 terragrunt 
    sudo chmod u+x terragrunt 
    sudo mv terragrunt /usr/local/bin/terragrunt
    terragrunt --version

    ## Install kubectl
    sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl 
    sudo chmod +x ./kubectl 
    sudo mv kubectl /usr/local/bin/
        
    ## INSTALL KUBECTX AND KUBENS
    sudo wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx 
    sudo wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens 
    sudo chmod +x kubectx kubens 
    sudo mv kubens kubectx /usr/local/bin

    ## Install Helm 3
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    sudo  chmod 700 get_helm.sh
    sudo ./get_helm.sh
    sudo helm version
}

## Create a file
cat << EOF > /usr/users.txt
jenkins
ansible 
ubuntu
EOF
username=$(cat /usr/users.txt | tr '[A-Z]' '[a-z]')

function user_add {
    ## Setting up users
    sudo groupadd tools

    for users in $username
    do
        ls /home |grep -w $users &>/dev/nul || mkdir -p /home/$users
        cat /etc/passwd |awk -F: '{print$1}' |grep -w $users &>/dev/nul ||  useradd $users
        chown -R $users:$users /home/$users
        usermod -s /bin/bash -aG tools $users
        usermod -s /bin/bash -aG docker $users
        echo -e "$users\n$users" |passwd "$users"
    done
    sudo echo -e '%atools  ALL=(ALL)  NOPASSWD:  ALL' >> /etc/sudoers
}

function webesite {
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2

    cd /var/www/html/
    sudo  rm -rf *

    sudo wget https://linux-devops-course.s3.amazonaws.com/covid19.zip
    sudo unzip covid19.zip
    sudo rm -rf covid19.zip

    sudo wget https://linux-devops-course.s3.amazonaws.com/creative.zip
    sudo unzip creative.zip 
    sudo rm -rf creative.zip

    sudo wget https://linux-devops-course.s3.amazonaws.com/halloween.zip
    sudo unzip halloween.zip 
    sudo  rm -rf halloween.zip

    sudo wget https://linux-devops-course.s3.amazonaws.com/static-website-example.zip
    sudo unzip static-website-example.zip 
    sudo rm -rf static-website-example.zip

    sudo wget https://linux-devops-course.s3.amazonaws.com/website.zip 
    sudo unzip website.zip 
    sudo rm -rf website.zip

    sudo wget https://linux-devops-course.s3.amazonaws.com/articles.zip
    sudo unzip articles.zip 
    sudo rm -rf articles.zip 
    sudo cp -r articles/* .
}

function jenkins {
    sudo apt-get update
    sudo apt-get install -y default-jdk
    sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list.d/jenkins.list
    sudo apt-get update
    sudo apt-get install -y jenkins
    # sudo systemctl start jenkins
    # sudo systemctl enable jenkins
}

software_installation
packages_installation
user_add
webesite
# jenkins