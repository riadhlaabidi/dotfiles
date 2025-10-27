#!/bin/sh

. util.sh

GO_DOWNLOAD_URL="https://go.dev/dl/?mode=json"
GO_ARCH="amd64"
GO_OS="linux"
GO_KIND="archive"

GO_STABLE=$(curl -s $GO_DOWNLOAD_URL)
TARGET_FILTER='.[0].files.[] | select(.os == $os and .arch == $arch and .kind == $kind)'
GO_TARGET=$(echo $GO_STABLE | jq --arg os "$GO_OS" --arg arch "$GO_ARCH" --arg kind "$GO_KIND" "$TARGET_FILTER")
GO_ARCHIVE=$(echo $GO_TARGET | jq -r '.filename')
GO_CHECKSUM=$(echo $GO_TARGET | jq -r '.sha256')

if [[ -z $GO_ARCHIVE ]]; then
    echo "Failed to fetch latest Go archive from $GO_DOWNLOAD_URL"
    echo "Os: $GO_OS, Arch: $GO_ARCH, Kind: $GO_KIND"
    exit 1
fi

pushd /tmp >/dev/null
if [[ -e $GO_ARCHIVE ]]; then
    rm -rf $GO_ARCHIVE
fi

wget -q --show-progress "https://go.dev/dl/$GO_ARCHIVE" 
echo "Download latest Go archive...[$(get_status $?)]"

if [[ -e $GO_ARCHIVE ]]; then

    echo "$GO_CHECKSUM $GO_ARCHIVE" > go_sha.txt

    sha256sum --check --status go_sha.txt
    sha_ec=$?
    echo "Verify checksum for the downloaded Go archive...[$(get_status $sha_ec)]"

    if [[ sha_ec -eq 0 ]]; then
        pushd /usr/local >/dev/null
        if [[ -d go ]]; then
            sudo rm -rf go/
            echo "Remove old Go installation...[$(get_status $?)]"
        fi
        popd >/dev/null
        sudo tar -xf $GO_ARCHIVE -C /usr/local >/dev/null
        echo "Unarchive Go...[$(get_status $?)]"
    fi

    rm -rf go_sha.txt
    rm -rf $GO_ARCHIVE
fi
popd >/dev/null
