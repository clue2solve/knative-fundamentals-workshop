FROM quay.io/eduk8s/base-environment:master

# This is needed until the base eduk8s image has `kn` included. 
USER root 
RUN curl -L -o /tmp/kn https://storage.googleapis.com/knative-nightly/client/latest/kn-linux-amd64 \
    && mv /tmp/kn /usr/local/bin/kn \
    && chmod 755 /usr/local/bin/kn 

USER 1001

COPY --chown=1001:0 . /home/eduk8s/

RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s

