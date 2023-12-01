#!/bin/bash
# Check if parameters is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <parameter> that represent part of github name"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Usage: $0 <parameter> that represent github email"
    exit 1
fi

eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_${1}

git config --global user.name "${1}"
git config --global user.email "${2}"




CORRECT_NAME=$1
CORRECT_EMAIL=$2

git filter-branch --env-filter '
    if [ -z "$GIT_COMMITTER_NAME" ]; then
        export GIT_COMMITTER_NAME="$CORRECT_NAME"
    fi
    if [ -z "$GIT_COMMITTER_EMAIL" ]; then
        export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    fi
    if [ -z "$GIT_AUTHOR_NAME" ]; then
        export GIT_AUTHOR_NAME="$CORRECT_NAME"
    fi
    if [ -z "$GIT_AUTHOR_EMAIL" ]; then
        export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
    fi
' --tag-name-filter cat -- --branches --tags

git push --force --all
git push --force --tags