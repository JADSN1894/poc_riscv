#!/bin/sh

set -ex

sudo apt-get update
sudo apt-get install build-essential opensbi u-boot-qemu file cpio bc -y

mkdir -p $HOME/.local/bin
cd $HOME/.local/bin

if [ X"${GH_TOKEN}" = X"" ];then 
    read -p "Paste here your Github personal access token: " GH_TOKEN
    export GH_TOKEN
fi

## Install Conventional Commits - Cocogitto (`cog`)
CURRENT_REPO="cocogitto/cocogitto"
CURRENT_VERSION=$(gh --repo $CURRENT_REPO release view --json tagName --jq .tagName)
DOWNLOADED_FILE=$(gh --repo $CURRENT_REPO release view --json assets --jq '.assets[] | select(.name | contains("x86_64") and contains("linux") and contains("musl")) .name')
gh --repo $CURRENT_REPO --pattern "$DOWNLOADED_FILE" release download $CURRENT_VERSION
tar -zxvf $DOWNLOADED_FILE x86_64-unknown-linux-musl
cp -v x86_64-unknown-linux-musl/cog ./
rm -rfv $DOWNLOADED_FILE x86_64-unknown-linux-musl
