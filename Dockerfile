FROM ubuntu:bionic-20190612
LABEL maintainer="patrickhub@github.com"

# Environment variables
ENV SQUID_VERSION=3.5.27 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

# Install Squid
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* && \
    rm -rf /var/lib/apt/lists/*

# Copy the Squid configuration file
COPY squid.conf /etc/squid/squid.conf

# Create required directories
RUN mkdir -p ${SQUID_CACHE_DIR} ${SQUID_LOG_DIR} && \
    chmod -R 755 ${SQUID_CACHE_DIR} ${SQUID_LOG_DIR} && \
    chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR} ${SQUID_LOG_DIR}

# Expose the Squid port
EXPOSE 3128

# Start Squid
CMD ["squid", "-N", "-f", "/etc/squid/squid.conf"]

