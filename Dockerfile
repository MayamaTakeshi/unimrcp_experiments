FROM debian:bullseye

ARG user_name
ARG git_user_name
ARG git_user_email

ARG USER_UID=1000
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && apt-get install -y autoconf automake build-essential cmake curl git-core gnupg jq libavdevice-dev libboost-dev libncurses5-dev libopencore-amrnb-dev libopencore-amrwb-dev libopus-dev libpcap-dev libsdl2-dev libspeex-dev libssl-dev libswscale-dev libtiff-dev libtool libtool-bin libv4l-dev libvo-amrwbenc-dev locales nano net-tools ngrep pkg-config python-dev rsyslog ruby subversion sudo swig tcpdump tmux tree uuid-dev vim wget tmuxinator
 
# install sip-lab deps
RUN apt-get -y install build-essential automake autoconf libtool libspeex-dev libopus-dev libsdl2-dev libavdevice-dev libswscale-dev libv4l-dev libopencore-amrnb-dev libopencore-amrwb-dev libvo-amrwbenc-dev libvo-amrwbenc-dev libboost-dev libtiff-dev libpcap-dev libssl-dev uuid-dev flite-dev cmake git wget 

# install sngrep deps
RUN apt-get -y install libpcap-dev libncurses5 libssl-dev libncursesw5-dev libpcre2-dev libz-dev

RUN <<EOF
set -o errexit
set -o nounset
set -o pipefail

mkdir -p /usr/local/src/git
cd /usr/local/src/git
git clone https://github.com/MayamaTakeshi/sngrep
cd sngrep/
git checkout mrcp_support
./bootstrap.sh
./configure --enable-unicode --with-pcre
make

ln -s `pwd`/src/sngrep /usr/local/bin/sngrep2

EOF

# Create the user
RUN groupadd --gid $USER_GID $user_name \
    && useradd --uid $USER_UID --gid $USER_GID -m $user_name

RUN echo $user_name ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$user_name \
    && chmod 0440 /etc/sudoers.d/$user_name

USER $user_name

RUN echo "set-option -g default-shell /bin/bash" >> ~/.tmux.conf

ENV TERM=xterm

RUN git config --global user.email $git_user_email
RUN git config --global user.name $git_user_name

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && echo "nvm installation OK"

RUN . ~/.nvm/nvm.sh && nvm install v21.7.0

RUN . ~/.nvm/nvm.sh && npm install -g yarn

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

RUN <<EOF cat > ~/.vimrc
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces

execute pathogen#infect()
syntax on
filetype plugin indent on

set background=dark
colorscheme zenburn
EOF


RUN <<EOF
set -o errexit
set -o nounset
set -o pipefail

# install vim zenburn color theme
mkdir -p ~/.vim/colors/
cd ~/.vim/colors/
wget https://raw.githubusercontent.com/jnurmine/Zenburn/de2fa06a93fe1494638ec7b2fdd565898be25de6/colors/zenburn.vim
EOF

RUN <<EOF cat >> ~/.bashrc
export LANG=C.UTF-8
export PS1='\u@\h:\W\$ '
export TZ=Asia/Tokyo
export TERM=xterm-256color
. ~/.nvm/nvm.sh
EOF
