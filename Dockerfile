# syntax=docker/dockerfile:1.3-labs

FROM debian:buster

ARG user_name
ARG git_user_name
ARG git_user_email

ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install -y sudo tmux curl git-core subversion gnupg locales wget nano vim jq tree rsyslog python-dev python-mysqldb net-tools tcpdump ngrep swig build-essential cmake libtool automake autoconf pkg-config libssl-dev

# Create the user
RUN groupadd --gid $USER_GID $user_name \
    && useradd --uid $USER_UID --gid $USER_GID -m $user_name

RUN echo $user_name ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$user_name \
    && chmod 0440 /etc/sudoers.d/$user_name

USER $user_name

SHELL ["/bin/bash", "--login", "-c"]

ENV TERM xterm

WORKDIR /home/$user_name

RUN echo "set-option -g default-shell /bin/bash" >> ~/.tmux.conf

RUN git config --global user.email $git_user_email
RUN git config --global user.name $git_user_name

RUN <<EOF cat > ~/.vimrc 
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces
EOF

RUN mkdir -p ~/src/git 

RUN cd ~/src \
  && wget --no-check-certificate https://www.unimrcp.org/project/component-view/unimrcp-deps-1-6-0-tar-gz/download -O unimrcp-deps-1.6.0.tar.gz \
  && tar -xzf unimrcp-deps-1.6.0.tar.gz \
  && cd unimrcp-deps-1.6.0 \
  && yes | sudo ./build-dep-libs.sh

RUN cd ~/src/git \
  && git clone https://github.com/unispeech/unimrcp \
  && cd unimrcp \
  && git checkout unimrcp-1.7.0 \
  && ./bootstrap \
  && ./configure \
  && make \
  && sudo make install

RUN cd ~/src/git \
  && git clone https://github.com/unispeech/swig-wrapper \
  && cd swig-wrapper \
  && git checkout 01af0d80a5dc9a08240095f4d49a377fb28e4c26 \
  && cmake -D APR_LIBRARY=/usr/local/apr/lib/libapr-1.so -D APR_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D APU_LIBRARY=/usr/local/apr/lib/libaprutil-1.so -D APU_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D UNIMRCP_SOURCE_DIR=/usr/local/src/git/unimrcp -D SOFIA_INCLUDE_DIRS=/usr/include/sofia-sip-1.12 -D WRAP_CPP=OFF -D WRAP_JAVA=OFF -D BUILD_C_EXAMPLE=OFF . \
  && make

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
 
RUN . ~/.nvm/nvm.sh && nvm install v16.17.0

RUN . ~/.nvm/nvm.sh && npm install -g yarn

RUN sudo apt install -y build-essential automake autoconf libtool libspeex-dev libopus-dev libsdl2-dev libavdevice-dev libswscale-dev libv4l-dev libopencore-amrnb-dev libopencore-amrwb-dev libvo-amrwbenc-dev libopus-dev libsdl2-dev libopencore-amrnb-dev libopencore-amrwb-dev libvo-amrwbenc-dev libboost-dev libtiff-dev libpcap-dev libssl-dev uuid-dev

RUN . ~/.nvm/nvm.sh && npm install -g sip-lab

#RUN sudo chown $user_name:$user_name -R ~/.config # hack to solve issue with npm update (see https://github.com/npm/npm/issues/17946)

RUN sudo sed -i -r 's|<ip type="auto"/>|<ip type="lo"/>|' /usr/local/unimrcp/conf/unimrcpserver.xml
RUN sudo sed -i -r 's|<ip type="auto"/>|<ip type="lo"/>|' /usr/local/unimrcp/conf/unimrcpclient.xml

RUN echo "PS1='\033[01;32m\]\u@unimrcp_dev\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

RUN mv ~/src/git/swig-wrapper/Python/*.so ~/src/git/swig-wrapper/Python/wrapper/

CMD ["bash"]

