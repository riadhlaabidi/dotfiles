#!/bin/sh

. util.sh

GO_VERSION="1.24.2"
GO_CHECKSUM="68097bd680839cbc9d464a0edce4f7c333975e27a90246890e9f1078c7e702ad"
GO_ARCHIVE="go$GO_VERSION.linux-amd64.tar.gz"

pushd /usr/local >/dev/null
if [[ -d go ]]; then
    sudo rm -rf go/
    echo "Remove old Go installation...[$(get_status $?)]"
fi
popd >/dev/null

pushd /tmp >/dev/null
if [[ -e $GO_ARCHIVE ]]; then
    rm -rf $GO_ARCHIVE
fi
wget "https://go.dev/dl/$GO_ARCHIVE" >/dev/null
echo "Download Go archive...[$(get_status $?)]"

if [[ -e $GO_ARCHIVE ]]; then
    echo "$GO_CHECKSUM $GO_ARCHIVE" > go_sha.txt

    sha256sum --check --status go_sha.txt
    sha_ec=$?
    echo "Verify checksum for Go archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        sudo tar -xf $GO_ARCHIVE -C /usr/local >/dev/null
        echo "Unarchive go...[$(get_status $?)]"
    fi

    rm -rf go_sha.txt
fi
popd >/dev/null
