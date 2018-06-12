# Ramit Mitra

# 0. Pull image
FROM centos:latest
RUN cat /etc/redhat-release

# A. Add EPEL, REMI & NodeJS yum repository
RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
RUN yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
RUN yum install -y gcc-c++ make -y
# B. Install YUM utilities
RUN yum install yum-utils -y
# C. Using yum-config-manager from yum-utils to enable REMI repository as the default repository for installing PHP
RUN yum-config-manager --enable remi-php72
# D. Installing DELTARPM to add magic for slow internet connection
## This will download only the differences with older versions of already installed packages
## This is done at the cost of increased processing time
### Also downloading required packages for next steps
RUN yum install deltarpm curl wget -y
# E. Fetch NodeJS 8.x
# RUN curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -

# 1. Ensure everything is updated to latest version
RUN yum clean all
RUN yum update -y
RUN yum upgrade -y
# removing orphaned yum data
RUN yum clean all
RUN rm -rf /var/cache/yum

# 2. Install JAVA
RUN yum install java-1.8.0-openjdk-devel -y
RUN java -version

# 3. Install PHP
RUN yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
RUN php -v

# 4. Install NodeJS
RUN yum install nodejs -y
RUN node -v
RUN npm -v

# 5. Install NodeJS Selenium Webdriver
RUN npm install selenium-webdriver -y

# 6. Fetch and install CHROME
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN chmod +x google-chrome-stable_current_x86_64.rpm
RUN yum install ./google-chrome-stable_current_*.rpm -y

# 5. Install FIREFOX
RUN yum -y install firefox Xvfb libXfont Xorg

# 6. Copy selenium-server-standalone jar
COPY selenium-server-standalone-3.9.1.jar /
RUN chmod +x selenium-server-standalone-3.9.1.jar

# 7. Run selenium-server as a background process
RUN nohup java -jar selenium-server-standalone-3.9.1.jar &
RUN ps
RUN ls -la /