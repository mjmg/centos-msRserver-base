FROM centos:latest

# Update System Image
RUN \
  yum update -y && \
  yum upgrade -y
  
#install additional tools 
RUN \
  yum install -y unzip wget curl
  
# Configure Supervisor
RUN \
  yum install -y python-setuptools && \
  easy_install pip && \
  pip install supervisor
  
# supervisor base configuration
ADD supervisord.conf /etc/supervisord.conf

# Instructions from https://msdn.microsoft.com/en-us/microsoft-r/rserver-install-linux-server

# Install OpenJDK8
RUN \
  yum install -y java-1.8.0-openjdk-headless make gcc gcc-c++ gfortran cairo-devel libicu libicu-devel nfs-utils nfs-utils-lib 
  
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0

# en_microsoft_r_server_for_linux_x64_8944657.tar.gz must exist in root directory with Dockerfile
COPY en_microsoft_r_server_for_linux_x64_8944657.tar.gz /tmp/en_microsoft_r_server_for_linux_x64_8944657.tar.gz

RUN \
  cd /tmp && \
  tar -xvzf en_microsoft_r_server_for_linux_x64_8944657.tar.gz 
  
RUN \
  cd /tmp/MRS80LINUX && \
  ./install.sh -a -d -p -u  
  
# Add default root password with password r00tpassw0rd
RUN \
  echo "root:r00tpassw0rd" | chpasswd  

# Add default RUser user with pass rstudio
RUN \
  useradd RUser && \
  echo "RUser:RUser" | chpasswd && \ 
  chmod -R +r /home/RUser && \ 
  chown -R RUser /usr/lib64/MRS80LINUX
  
# default command
CMD ["/usr/bin/Revo64"]
