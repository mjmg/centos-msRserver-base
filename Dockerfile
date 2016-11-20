FROM centos:latest

# Update System Image
RUN \
  yum update -y && \
  yum upgrade -y
  
#install additional tools 
RUN \
  yum install -y unzip wget
  
# Configure Supervisor
RUN \
  yum install supervisor
  
# supervisor base configuration
ADD supervisord.conf /etc/supervisord.conf

# default command
CMD ["/bin/bash"]
