FROM ubuntu
RUN apt-get update -y \
  && apt-get clean \
  apt-get install build-essential -y\
  && apt-get install -y locales \
  && locale-gen en_US.UTF-8

ENV TERM=xterm
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.1.2
ENV YARN_VERSION 0.24.6

ADD packages.txt /tmp/packages.txt
ADD requirements.txt /tmp/requirements.txt

RUN apt-get update -y \
  && xargs -a /tmp/packages.txt apt-get install -y

RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
RUN npm config set unsafe-perm=true

RUN apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home --home-dir /home/ds --shell /bin/bash ds \
  && mkdir -p /home/ds \
  && mkdir /home/ds/mnt \
  && chown -R ds /home/ds \
  && adduser ds sudo \
  && usermod -a -G sudo ds \
  && echo "ds ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -aG sudo ds

RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

RUN pip3 install --upgrade pip
RUN pip3 install -r /tmp/requirements.txt

RUN npm install -g configurable-http-proxy
RUN pip3 install jupyterhub

COPY ./entrypoint.sh /
RUN chown -R ds /entrypoint.sh

USER ds
ENV HOME=/home/ds/mnt
ENV SHELL=/bin/bash
ENV USER=ds
VOLUME /home/ds/mnt
WORKDIR /home/ds/mnt
ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]
CMD ["jupyter-lab", "--ip=*"]
EXPOSE 8000
