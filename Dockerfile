# syntax=docker/dockerfile:1.3-labs

FROM debian:buster

ARG user_name
ARG git_user_name
ARG git_user_email

ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install -y autoconf automake build-essential cmake curl git-core gnupg jq libavdevice-dev libboost-dev libncurses5-dev libopencore-amrnb-dev libopencore-amrwb-dev libopus-dev libpcap-dev libsdl2-dev libspeex-dev libssl-dev libswscale-dev libtiff-dev libtool libv4l-dev libvo-amrwbenc-dev locales nano net-tools ngrep pkg-config python-dev python-mysqldb rsyslog ruby subversion sudo swig tcpdump tmux tree uuid-dev vim wget
 
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

RUN cd ~ \
  && wget --no-check-certificate https://www.unimrcp.org/project/component-view/unimrcp-deps-1-6-0-tar-gz/download -O unimrcp-deps-1.6.0.tar.gz \
  && tar -xzf unimrcp-deps-1.6.0.tar.gz \
  && cd unimrcp-deps-1.6.0 \
  && yes | sudo ./build-dep-libs.sh

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
 
RUN . ~/.nvm/nvm.sh && nvm install v16.17.0

RUN . ~/.nvm/nvm.sh && npm install -g yarn

RUN . ~/.nvm/nvm.sh && npm install -g sip-lab

RUN echo "PS1='\033[01;32m\]\u@unimrcp_dev\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

# Install sngrep with MRCP support
RUN cd ~/src/git \
    && git clone https://github.com/MayamaTakeshi/sngrep \
    && cd sngrep \
    && git checkout mrcp_support \
    && ./bootstrap.sh \
    && ./configure \
    && make \
    && sudo make install

# install tmuxinator (old version because Debian 10 uses old ruby)
RUN sudo gem install tmuxinator -v 1.1.5

CMD ["bash"]

