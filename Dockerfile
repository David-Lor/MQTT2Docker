FROM alpine:latest

# Env vars
ARG DEFAULT_MQTT_UID=1000
ENV MQTT_HOST mqtt \
    MQTT_UID 1000

# Install dependencies
RUN apk --no-cache update && apk --no-cache add mosquitto-clients jq curl

# Create non-root user
RUN addgroup -g $DEFAULT_MQTT_UID user && adduser -D -H -G user -u $DEFAULT_MQTT_UID user

# Copy script
ARG SCRIPT="mqtt2docker/mqtt2docker.sh"
COPY ${SCRIPT} /entrypoint.sh

# Execute
CMD ["sh", "/entrypoint.sh"]
