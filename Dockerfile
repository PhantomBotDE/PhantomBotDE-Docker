# Base docker image
FROM openjdk:11-jre-slim
LABEL maintainer "PhantomBotDE"

# environment variables
ARG PV=3.3.0
ARG DATE="`/bin/date +\%Y-\%m-\%d-\%H_\%M_\%S_\%3N`"

# Install Dependencies
RUN apt update && apt install -y bash curl wget unzip cron dirmngr

# phantombot installation
RUN mkdir -p /root/tmp && \
        cd /root/tmp && \
        wget https://github.com/PhantomBotDE/PhantomBotDE/releases/download/v${PV}/PhantomBotDE-${PV}.zip && \
        unzip PhantomBotDE-${PV}.zip && \
        rm PhantomBotDE-${PV}.zip && \
        mkdir /phantombotde && \
        mv PhantomBotDE-${PV}/* /phantombotde && \
        chmod u+x /phantombotde/launch-service.sh /phantombotde/launch.sh /phantombotde/java-runtime-linux/bin/java

# remove leftovers
RUN cd && \
        rm -rf /root/tmp

#RUN echo "cd phantombot && ./launch-service.sh" > /start-phantombot
COPY wrapper.sh /wrapper.sh
#RUN chmod a+x /start-phantombot
RUN chmod a+x /wrapper.sh

# Run
CMD /wrapper.sh


