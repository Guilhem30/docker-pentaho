

FROM wmarinho/ubuntu:oracle-jdk-7


MAINTAINER Wellington Marinho wpmarinho@globo.com

# Init ENV
ENV BISERVER_TAG 5.3.0.0-213

ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV PENTAHO_JAVA_HOME $JAVA_HOME

RUN apt-get update \
	&& apt-get install wget unzip git -y 

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Download Pentaho BI Server
#RUN /usr/bin/wget -nv  http://ufpr.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/5.2/biserver-ce-${BISERVER_TAG}.zip -O /tmp/biserver-ce-${BISERVER_TAG}.zip 
RUN usr/bin/wget -nv http://softlayer-ams.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/5.3/biserver-ce-${BISERVER_TAG}.zip -O /tmp/biserver-ce-${BISERVER_TAG}.zip

RUN /usr/bin/unzip -q /tmp/biserver-ce-${BISERVER_TAG}.zip -d  $PENTAHO_HOME
RUN rm -f /tmp/biserver-ce-${BISERVER_TAG}.zip $PENTAHO_HOME/biserver-ce/promptuser.sh



RUN rm -f /tmp/biserver-ce-${BISERVER_TAG}.zip

ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle


RUN apt-get install postgresql-client-9.3 -y

ADD config $PENTAHO_HOME/config
ADD scripts $PENTAHO_HOME/scripts
ADD scripts/run.sh /

RUN sed -i -e 's/\(exec ".*"\) start/\1 run/' /opt/pentaho/biserver-ce/tomcat/bin/startup.sh &&\
    chmod +x $PENTAHO_HOME/biserver-ce/start-pentaho.sh

RUN apt-get install zip -y


EXPOSE 8080 
CMD ["./run.sh"]
