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
	&& apk add curl \
	&& rm -rf /var/cache/*/* \
	&& echo "" > /root/.ash_history

RUN mkdir -p /build
RUN cd /build
COPY build-entrypoint.sh /build
RUN chmod +x build/build.sh

# Put the directories required by appup maven
RUN mkdir -p /appup_lib/jars/appup_jars /appup_lib/jars/dependencies 

ENTRYPOINT [ "build/build.sh" ]