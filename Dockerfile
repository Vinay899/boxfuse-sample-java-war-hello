FROM ubuntu:18.04
MAINTAINER Ziyan Akthar <ziyanakthar@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y git
# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

# Install JDK 8 (latest edition)
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk curl

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN mkdir /home/jenkins/.m2

echo "<settings>
<servers>
    <server>
      <id>repo</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
</servers>
</settings>" > settings.xml
ADD settings.xml /home/jenkins/.m2/
1	
RUN chown -R jenkins:jenkins /home/jenkins/.m2/ 

RUN apt-get install -y maven
# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
