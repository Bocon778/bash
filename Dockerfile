FROM debian:bookworm-slim

LABEL maintainer="Bocon <bocon@bloxbind.com>"

RUN apt update \
    && apt upgrade -y \
    && apt -y install curl wget unzip zip tar \
    && apt -y install software-properties-common locales git \
    && apt-get -y install liblzma-dev lzma \
    && apt -y install cmake \
    && adduser container

RUN apt-get update && \
    apt-get -y install sudo   

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

RUN apt update \
    && apt install -y libc6-i386 libc6-x32 \
    && wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb -O jdk-21_linux-x64_bin.deb \
    && apt install -y ./jdk-21_linux-x64_bin.deb \
    && rm jdk-21_linux-x64_bin.deb

ENV JAVA_HOME=/usr/lib/jvm/jdk-21/
ENV PATH=$PATH:$JAVA_HOME/bin

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get -y install nodejs imagemagick ffmpeg make build-essential 

ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install 20 \
    && nvm install 22 \
    && nvm install 24 \
    && nvm alias default 24

ENV NODE_VERSION=24
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm i -g pnpm

RUN apt update \
    && apt -y install zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev \
    && wget https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz \
    && tar -xf Python-3.12.*.tgz \
    && cd Python-3.12.1 \
    && ./configure --enable-optimizations \
    && make -j $(nproc) \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.12.1 \
    && rm Python-3.12.*.tgz 

RUN apt -y install python3 python3-pip python3-venv \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip

RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \ 
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y aspnetcore-runtime-6.0 dotnet-sdk-6.0 

RUN apt-get install -y \
    fonts-liberation \
    libatk1.0-0 \
    libcairo2 \
    libfontconfig1 \
    libgbm-dev \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libjpeg-dev \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6

USER container
ENV USER=container
ENV HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]