ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

FROM nodered/node-red:${VERSION}

RUN npm install node-red-contrib-home-assistant-websocket \
                node-red-contrib-boolean-logic-ultimate \
                node-red-contrib-loop-processing \
                node-red-contrib-counter \
                node-red-contrib-cast \
                node-red-contrib-bigtimer \
                node-red-contrib-time-range-switch \
                node-red-contrib-cron-plus \
                node-red-contrib-calc \
                node-red-contrib-stoptimer \
                node-red-contrib-themes/midnight-red \
                node-red-contrib-moment \
                # node-red-contrib-iiot-ntptime \
                node-red-contrib-telegrambot
