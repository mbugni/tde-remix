ARG IMAGE_REGISTRY=docker.io
FROM $IMAGE_REGISTRY/debian:12.10-slim
ENTRYPOINT ["/bin/sh","-c"]
RUN apt update && \
apt --assume-yes upgrade && \
apt --assume-yes install bash-completion python3-pip kiwi-systemdeps-iso-media && \
pip3 install --exists-action=i --break-system-packages kiwi==v10.2.19 && \
apt autoclean
