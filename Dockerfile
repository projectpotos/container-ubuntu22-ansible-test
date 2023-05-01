FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="Project Potos"
LABEL org.opencontainers.image.source="https://github.com/projectpotos/container-ubuntu22-ansible-test"
LABEL org.opencontainers.image.title="Ubuntu 22.04 Ansible Test"
LABEL org.opencontainers.image.description="Ubuntu 22.04 container image for testing Ansible roles, playbooks and collections."
LABEL org.opencontainers.image.base.name="docker.io/_/ubuntu:latest"

# See also https://systemd.io/CONTAINER_INTERFACE
ENV container docker

# Install systemd and python3-certifi
RUN apt-get update && apt-get install -y --no-install-recommends \
    systemd \
    init \
    python3 \
    python3-certifi \
    && \
    apt-get clean

# Remove systemd 'wants' triggers
RUN find \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/multi-user.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    ! -type d \
    -delete

# Remove all sysinit targets and everything except tmpfiles setup in sysinit
# target
RUN find \
    /lib/systemd/system/sysinit.target.wants \
    ! -type d \
    ! -name '*systemd-tmpfiles-setup*' \
    -delete

# Remove UTMP updater service
RUN find \
    /lib/systemd \
    -name systemd-update-utmp-runlevel.service \
    -delete

# Disable /tmp mount
RUN rm -vf /usr/share/systemd/tmp.mount

# Fix missing BPF firewall support warning
RUN sed -ri '/^IPAddressDeny/d' /lib/systemd/system/systemd-journald.service

# Just for cosmetics, fix "not-found" entries while using "systemctl --all"
RUN for MATCH in \
        plymouth-start.service \
        plymouth-quit-wait.service \
        syslog.socket \
        syslog.service \
        display-manager.service \
        systemd-sysusers.service \
        tmp.mount \
        systemd-udevd.service \
        ; do \
            grep -rn --binary-files=without-match  ${MATCH} /lib/systemd/ | cut -d: -f1 | xargs sed -ri 's/(.*=.*)'${MATCH}'(.*)/\1\2/'; \
        done && \
        systemctl set-default multi-user.target

# Required by systemd
VOLUME ["/sys/fs/cgroup"]

# Execute systemd at start
CMD ["/lib/systemd/systemd"]
