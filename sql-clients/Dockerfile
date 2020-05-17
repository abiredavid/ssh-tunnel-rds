FROM amazonlinux:2

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo && \
    yum update -y && \
    yum install -y \
         mysql \
         mssql-cli
   
