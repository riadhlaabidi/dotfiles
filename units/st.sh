#!/bin/sh 

. util.sh

pushd /usr/local &>/dev/null
if [[ -d st ]]; then
 sudo rm -rf st/ &>/dev/null
 echo "Remove old st installation...[$(get_status $?)]"
fi
popd &>/dev/null

pushd /tmp &>/dev/null
git clone "$GIT_SSH/st.git" --depth=1 &>/dev/null
echo "Download st repo...[$(get_status $?)]"

sudo mv st /usr/local/st &>/dev/null
echo "Move st repo...[$(get_status $?)]"
popd &>/dev/null

# install st build deps
sudo dnf install -y make gcc fontconfig-devel libXft-devel
echo "Install st deps...[$(get_status $?)]"

pushd /usr/local &>/dev/null
if [[ -d st ]]; then
    cd st/
    sudo make clean install &>/dev/null
    echo "Build and install st...[$(get_status $?)]"
fi
popd &>/dev/null
