FROM rockylinux:9.3

LABEL frame="frame"

# Install dependencies
RUN dnf -y update && \
    dnf -y install nc nano wget tar unzip bzip2 bind-utils net-tools procps

# Create splunk user and group
RUN groupadd splunk && \
    useradd -m -d /opt/splunk -g splunk splunk

# Download and install Splunk
RUN wget -O /tmp/splunk-9.2.2-d76edf6f0a15-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.2.2/linux/splunk-9.2.2-d76edf6f0a15-Linux-x86_64.tgz" && \
    tar -xvzf /tmp/splunk-9.2.2-d76edf6f0a15-Linux-x86_64.tgz -C /opt && \
    rm -rf /tmp/splunk-9.2.2-d76edf6f0a15-Linux-x86_64.tgz

# Set permissions
RUN chown -R splunk:splunk /opt/splunk

# Copy the user-seed.conf for initial admin setup
COPY user-seed.conf /opt/splunk/etc/system/local/user-seed.conf

EXPOSE 8000 8089 9997

ENV SPLUNK_HOME=/opt/splunk
ENV PATH=${SPLUNK_HOME}/bin:${PATH}

USER splunk

# Start Splunk
#ENTRYPOINT ["/opt/splunk/bin/splunk", "start", "--accept-license", "--answer-yes", "--no-prompt"]

