# Main Maven
FROM openjdk:8-alpine

LABEL Maintainer="500APPS <info@500apps.com>" \
	  Description="This is build docker of Appup" 

# This docker needs to build a docker internally. It needs aws to upload to ecr.


# Update
RUN apk update \
	&& apk upgrade \
	&& apk add bash \
	&& apk add python3 \
	&& apk add maven \
	&& apk add jq \
	&& apk add curl \
	&& rm -rf /var/cache/*/* \
	&& echo "" > /root/.ash_history

# Install AWS
RUN pip3 install --upgrade awscli

# Docker cannot copy from root - we need to run build from root. Hence absolute paths.
RUN mkdir -p /appup_lib/jars
COPY jars /appup_lib/jars

COPY /appup_lib/ /appup_lib/

RUN mkdir server
COPY log4j2.xml /server/
COPY start_app.sh /server/
COPY stepsAndPlugins.json /appup_lib/
COPY  settings.xml /usr/share/java/maven-3/conf
RUN chmod +x /server/start_app.sh


CMD [ "/server/start_app.sh" ]ls
