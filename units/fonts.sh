#!/bin/sh

. util.sh

JBM_CHECKSUM="2d83782a350b604bfa70fce880604a41a7f77c3eec8f922f9cdc3c20952ddbe4"
JBM_ARCHIVE="JetBrainsMono.zip"

if [[ ! -d /usr/local/share/fonts ]]; then
    sudo mkdir /usr/local/share/fonts &>/dev/null
    echo "Create user fonts dir...[$(get_status $?)]"
fi

pushd /usr/local/share/fonts &>/dev/null
if [[ -d JetBrainsMono ]]; then
    sudo rm -rf JetBrainsMono/
    echo "Remove old JetBrainsMono font...[$(get_status $?)]"
fi
sudo mkdir JetBrainsMono
popd &>/dev/null

pushd /tmp &>/dev/null
if [[ -e $JBM_ARCHIVE ]]; then
    rm -rf $JBM_ARCHIVE
fi

wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$JBM_ARCHIVE" &>/dev/null
echo "Download JetbrainsMono archive...[$(get_status $?)]"

if [[ -e $JBM_ARCHIVE ]]; then
    echo "$JBM_CHECKSUM $JBM_ARCHIVE" > jb_mono_sha.txt

    sha256sum --check --status jb_mono_sha.txt
    sha_ec=$?
    echo "Verify checksum for JetbrainsMono archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        sudo unzip $JBM_ARCHIVE -d /usr/local/share/fonts/JetBrainsMono &>/dev/null
        echo "Unarchive JetbrainsMono...[$(get_status $?)]"
    fi

    rm -rf jb_mono_sha.txt
fi

fc-cache -f &>/dev/null
echo "Update font cache...[$(get_status $?)]"
popd &>/dev/null
