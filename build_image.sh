#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail


function usage() {
    cat <<EOF
Usage: $0 [-u git_user_name ] [-e git_user_email]
EOF
}

git_user_name=""
git_user_email=""

if [[ -e .git_user.json ]]
then
    git_user_name=`jq -r .name .git_user.json`
    git_user_email=`jq -r .email .git_user.json`
fi

while getopts "u:e:h" flag;do
case "$flag" in
u) git_user_name="$OPTARG";;
e) git_user_email="$OPTARG";;
h) usage; exit 0;;
?) usage; exit 1;;
esac
done
shift $(($OPTIND - 1))

if [[ "$git_user_name" == "" ]]
then
    set +o errexit
    git_user_name=`git config --global --get user.name`
    set -o errexit
fi

if [[ "$git_user_email" == "" ]]
then
    set +o errexit
    git_user_email=`git config --global --get user.email`
    set -o errexit
fi

if [[ "$git_user_name" == "" ]]
then
    echo "I could not resolve your git user.name. Please input it now:"
    read git_user_name
fi

if [[ "$git_user_email" == "" ]]
then
    echo "I could not resolve your git user.email. Please input it now:"
    read git_user_email
fi

cat > .git_user.json <<EOF
{
    "name": "$git_user_name",
    "email": "$git_user_email"
}
EOF

DOCKER_BUILDKIT=1 docker build --network=host --rm -f Dockerfile -t unimrcp --build-arg user_name=$(whoami) --build-arg git_user_name=$git_user_name --build-arg git_user_email=$git_user_email .

