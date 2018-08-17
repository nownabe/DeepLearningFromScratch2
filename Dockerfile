FROM nvidia/cuda:9.0-devel-ubuntu16.04

ENV python_version 3.7.0

ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG="en_US.UTF-8"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libncursesw5-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
    libsqlite3-dev \
    libssl-dev \
    openssl \
    tk-dev \
    xz-utils \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*


# Install Python

RUN curl -fsSL -o /usr/local/src/python.tar.xz \
  https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tar.xz \
  && tar xf /usr/local/src/python.tar.xz -C /usr/local/src/ \
  && cd /usr/local/src/Python-${python_version} \
  && ./configure \
  && make -j $(nproc) \
  && make install \
  && ldconfig \
  && rm -rf /usr/local/src/python.tar.xz /usr/local/src/Python-${python_version} \
  && ln -s /usr/local/bin/pip3 /usr/local/bin/pip \
  && ln -s /usr/local/bin/python3 /usr/local/bin/python

RUN pip install --upgrade pip
RUN pip install pipenv

RUN mkdir -p /app
WORKDIR /app

ADD Pipfile Pipfile.lock /app/
RUN pipenv install
