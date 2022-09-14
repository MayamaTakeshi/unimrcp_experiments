# syntax=docker/dockerfile:1.3-labs

FROM debian:buster

RUN apt-get update && apt-get install -y sudo tmux curl git-core subversion gnupg locales wget nano vim jq tree rsyslog python-dev python-mysqldb net-tools tcpdump ngrep swig build-essential cmake libtool automake autoconf pkg-config libssl-dev


SHELL ["/bin/bash", "--login", "-c"]

RUN echo "set-option -g default-shell /bin/bash" >> ~/.tmux.conf

ENV TERM xterm

RUN <<EOF cat > ~/.vimrc 
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces
EOF

RUN mkdir -p /root/src/git 

RUN cd /root/src \
  && wget --no-check-certificate https://www.unimrcp.org/project/component-view/unimrcp-deps-1-6-0-tar-gz/download -O unimrcp-deps-1.6.0.tar.gz \
  && tar -xzf unimrcp-deps-1.6.0.tar.gz \
  && cd unimrcp-deps-1.6.0 \
  && yes | ./build-dep-libs.sh

RUN cd /root/src/git \
  && git clone https://github.com/unispeech/unimrcp \
  && cd unimrcp \
  && git checkout unimrcp-1.7.0 \
  && ./bootstrap \
  && ./configure \
  && make \
  && make install

RUN cd /root/src/git \
  && git clone https://github.com/unispeech/swig-wrapper \
  && cd swig-wrapper \
  && git checkout 01af0d80a5dc9a08240095f4d49a377fb28e4c26 \
  && cmake -D APR_LIBRARY=/usr/local/apr/lib/libapr-1.so -D APR_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D APU_LIBRARY=/usr/local/apr/lib/libaprutil-1.so -D APU_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D UNIMRCP_SOURCE_DIR=/usr/local/src/git/unimrcp -D SOFIA_INCLUDE_DIRS=/usr/include/sofia-sip-1.12 -D WRAP_CPP=OFF -D WRAP_JAVA=OFF-D BUILD_C_EXAMPLE=OFF . \
  && make


CMD ["bash"]

