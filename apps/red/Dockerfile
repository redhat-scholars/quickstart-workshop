# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8-minimal
FROM registry.redhat.io/web-terminal/web-terminal-tooling-rhel8:1.5-1.1655140453
USER 0

# The $INITIAL_CONFIG dir stores dotfiles (e.g. .bashrc) for the web terminal, which
# are copied into $HOME when the container starts up. This allows defining a default
# configuration that can still be overridden if necessary (the copy does not overwrite
# existing files)
ENV HOME=/home/user
WORKDIR /home/user
ENV OPENSHIFT_RELEASE_VERSION="4.10.26"

RUN echo "PS1=\"[redshell \W]\$\"" >> $INITIAL_CONFIG/.bashrc

RUN mkdir -p /home/user && \
    microdnf update -y && \
    microdnf install -y \
    # bash completion tools
    bash-completion ncurses pkgconf-pkg-config findutils \
    # terminal-based editors
    vi vim nano \
    # developer tools
    npm nodejs \
    tar diff\
    curl git procps jq && \
    microdnf -y clean all

RUN curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod a+x /usr/local/bin/yq

RUN curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OPENSHIFT_RELEASE_VERSION/openshift-client-linux-$OPENSHIFT_RELEASE_VERSION.tar.gz -o /tmp/openshift-client-linux-$OPENSHIFT_RELEASE_VERSION.tar.gz && \
    tar -xvf /tmp/openshift-client-linux-$OPENSHIFT_RELEASE_VERSION.tar.gz -C /tmp && \
    mv /tmp/oc /usr/local/bin/oc && \
    mv /tmp/kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/oc && \
    chmod +x /usr/local/bin/kubectl && \
    rm /tmp/openshift-client-linux* /tmp/README.md

RUN curl -L https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/odo/v3.0.0~beta3/odo-linux-amd64 -o /usr/local/bin/odo && \
    chmod +x /usr/local/bin/odo

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]

ENV SUMMARY="Red Shell - Tooling container" \
    DESCRIPTION="Red Shell - Tooling container" \
    PRODNAME="web-terminal" \
    COMPNAME="tooling" \
    PS1="[redshell \W]\$"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$DESCRIPTION" \
      io.openshift.tags="$PRODNAME,$COMPNAME" \
      com.redhat.component="$PRODNAME-$COMPNAME-container" \
      name="$PRODNAME/$COMPNAME" \
      version="1.5" \
      license="EPLv2" \
      maintainer="Angel Misevski <amisevsk@redhat.com>" \
      io.openshift.expose-services="" \
      usage=""
