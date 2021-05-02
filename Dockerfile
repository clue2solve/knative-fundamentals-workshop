FROM quay.io/eduk8s/base-environment:master

COPY --chown=1001:0 . /home/eduk8s/

RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s

RUN curl -L -o /usr/local/bin/kn https://storage.googleapis.com/knative-nightly/client/latest/kn-linux-amd64 \
  && chmod 755 /usr/local/bin/kn