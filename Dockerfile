# Base docker image
FROM openjdk:8-jre-alpine
LABEL maintainer "Daevien <github@daevien.com>"

# environment variables
ARG PV=3.2.0
ARG DATE="`/bin/date +\%Y-\%m-\%d-\%H_\%M_\%S_\%3N`"

# Install Dependencies
RUN apk add --no-cache bash curl wget unzip

# phantombot installation
RUN mkdir -p /root/tmp && \
        cd /root/tmp && \
        wget https://github.com/PhantomBot/PhantomBot/releases/download/v${PV}/PhantomBot-${PV}-lin.zip && \
        unzip PhantomBot-${PV}-lin.zip && \
        rm PhantomBot-${PV}-lin.zip && \
        mkdir /phantombot && \
        mv PhantomBot-${PV}/PhantomBot-${PV}/* /phantombot && \
        sudo chmod u+x /phantombot/launch-service.sh /phantombot/launch.sh /phantombot/java-runtime-linux/bin/java

# remove leftovers
RUN apk del --no-cache wget unzip
RUN cd && \
        rm -rf /root/tmp

# backup
RUN echo "#!/bin/sh" > /etc/periodic/daily/phantombot
RUN echo "37 2 */1 * *  umask 0007;/bin/tar --exclude 'phantombot/web' --exclude 'phantombot/lib' -cjf /backup/${DATE}.tar.bz2 /phantombot >> /backup/backup_phantombot.log 2>&1" >> /var/spool/cron/crontabs/root
RUN chmod a+x /var/spool/cron/crontabs/root

# Cron job + wrapper script
RUN echo "crond" > /start-crond
RUN echo "cd phantombot && ./launch-service.sh" > /start-phantombot
#COPY wrapper.sh /wrapper.sh
RUN chmod a+x /start-crond
RUN chmod a+x /start-phantombot
#RUN chmod a+x /wrapper.sh

# Run
#CMD ./wrapper.sh
CMD ./launch_service.sh





