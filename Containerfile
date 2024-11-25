ARG REGISTRY_PREFIX=docker.io
FROM $REGISTRY_PREFIX/debian:12.8-slim
RUN apt update && \
apt --assume-yes upgrade && \
apt --assume-yes install bash-completion python3-pip kiwi-systemdeps-iso-media && \
pip3 install --exists-action=i --break-system-packages kiwi==10.2.0 && \
apt autoclean
