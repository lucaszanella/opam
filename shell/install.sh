#!/bin/sh

set -ue

# (c) Copyright Fabrice Le Fessant INRIA/OCamlPro 2013
# (c) Copyright Louis Gesbert OCamlPro 2014-2017

VERSION='2.0.7'
DEV_VERSION='2.1.0~alpha'
DEFAULT_BINDIR=/usr/local/bin

bin_sha512() {
  case "$OPAM_BIN" in
    opam-2.0.6-arm64-linux)     echo "d2b3d92fd5fae7f053702b53ddbc7c224fcfbfc9b232247ba4e40cbf1cda28f160d8c14fde87aebeebfd2545e13265c0ee4a47e292f035767fb944b1b8ff5c90";;
    opam-2.0.6-armhf-linux)     echo "a42a7ad8c1afdb20ac5746934306576e6364f5453b176ccd42a3e5a116a5db05c2758cec31800ffab11411290cf671f9eee3f299df48c7ceca8e4d7e33dfedc8";;
    opam-2.0.6-i686-linux)      echo "6c0d965f89a2026ead3120e217d12b2df7426740d54bc94e2c46faaeff5893081e68aac162621bfa694ab597a18be28165f10cdda1217a4d73653789a9928b64";;
    opam-2.0.6-x86_64-linux)    echo "2b9d4a99aa28a193c88c7c6f6265203bd3cfeef98929d6f5cfce4b52cd9ddbd7be7eddc1d3d9c440f81d65074dd7851b8d29cd397fb06d2cfccffb54d3cdcc6a";;
    opam-2.0.6-x86_64-macos)    echo "cf02546b22ca91b1d97a3657b970b34d4acf4dc745696b7200ff185d25ebb5914ea8b6a94b503eb8c999634de6fdb944998a970105cd6a4c6df538c262b48b7f";;
    opam-2.0.6-x86_64-openbsd)  echo "2f58b3d4902d4c3fb823d251a50e034f9101b0c5a3827725876bb3bcb6c013c4f54138054d82abba0a9e917675275e26f05b98630cf7116c465d2110756f1309";;

    opam-2.0.7-arm64-linux)     echo "0dd4d80496545f684af39dc5b4b28867bc19a74186577c38bd2a8934d871c2cbcdb9891bfd41c080b5f12d5a3c8801e203df8a76d55e1e22fe80d31447402e46";;
    opam-2.0.7-armhf-linux)     echo "ea691bc9565acc1207dea3dfb89192b1865b5b5809efe804a329f39878640fb19771edcb05c5699f8e914e88e3155f31132b845c54b0095bedd3952d336bae0b";;
    opam-2.0.7-i686-linux)      echo "5fa8fb9664d36ead5760e7e1c337f6ae7b0fd4be5089ddfb50ae74028deec30893b1f4dee040402bc3f15da197ba89a45c7d626ecf6e5be80d176f43526c4bad";;
    opam-2.0.7-x86_64-linux)    echo "da75b0cb5ad50f95d31857a7d72f1836132a1fa1cdbfdedf684342b798e7107b4add4c74c05d5ce44881309fa1e57707538dbcda874e7f74b269b1bb204f3ae3";;
    opam-2.0.7-x86_64-macos)    echo "de1194c8e97e53956e5e47502c28881bbf26d1beaac4f33a43a922b8ca7ce97725533cfaf65a33fc0e183eab5a95e9ecd2e20f72faeaec333dc3850b79b5fe8a";;
    opam-2.0.7-x86_64-openbsd)  echo "b253809c4388847e1a33b5c4f1f5d72bef79a2f0c43b19ef65b40d0c10341aa0bee4a4b1f3a9ab70eb026e4cc220a63cfc56a18c035b6b0297c92f2bdb7f9a78";;

    opam-2.1.0-alpha-arm64-linux)     echo "1bf0acfa64aa01c3244e65eed60eef1caaa6de53aa8b32dd0d2446f91905a1e41591f53cd350e85b2b9f5edba9b137d723c32949115623e9753e77b707bb25b0";;
    opam-2.1.0-alpha-armhf-linux)     echo "87c12a422bd14a0d10a94ddaaa46de23700e3b89810a0c06232eff8d96b37c2fd43dcb5a8da5a2004aa8040d1b93293209f1ff1aab865ffd150364e24c87c716";;
    opam-2.1.0-alpha-i686-linux)      echo "b8369da6d4795a461ff1b49e687b027325d4e90bc8f19517e52a94ee3be167c4faaaf33bd0b3536be552d2add54865d0e33933acaa674f2e1a17249b022738af";;
    opam-2.1.0-alpha-x86_64-linux)    echo "2e22747829fb0bada3a74a23f5e0ff2228520d647fc4fe08a1ce76f3cb357cc7240f7b45e422c5f4b8eafe832ae3a8973ecbd4814ae0e8ce1096bcff39482020";;
    opam-2.1.0-alpha-x86_64-macos)    echo "c440e8ae1970fa7533e6e1b96ba3e3dd65b04432d41bc57ce4c768ed9b4229954546d59ec06f3d4ee49cbe00bb4bfd0b3f509d6d9a27de2db17725e097a61c86";;
    opam-2.1.0-alpha-x86_64-openbsd)  echo "d87afe99fee541a1c6fae30b72653db7a5ea2abdec3fa3b2b480daddf3fcd8d4096e2a40458310755faec3722119f29ed981ffbfa65142e618f99b70572f892f";;
    *) echo "no sha";;
  esac
}

usage() {
    echo "opam binary installer v.$VERSION"
    echo "Downloads and installs a pre-compiled binary of opam $VERSION to the system."
    echo "This can also be used to switch between opam versions"
    echo
    echo "Options:"
    echo "    --dev                  Install the latest alpha or beta instead: $DEV_VERSION"
    echo "    --no-backup            Don't attempt to backup the current opam root"
    echo "    --no-interaction       Don't ask for user interaction, use default installation path"
    echo "    --disable-sandboxing   Disables sandboxing, needed for using inside docker"
    echo "    --backup               Force the backup the current opam root (even if it"
    echo "                           is from the 2.0 branch already)"
    echo "    --fresh                Create the opam $VERSION root from scratch"
    echo "    --restore   VERSION    Restore a backed up opam binary and root"
    echo
    echo "The default is to backup if the current version of opam is 1.*, or when"
    echo "using '--fresh' or '--dev'"
}

RESTORE=
NOBACKUP=
FRESH=
NO_INTERACTION=
DISABLE_SANDBOXING=

while [ $# -gt 0 ]; do
    case "$1" in
        --dev)
            VERSION=$DEV_VERSION
            if [ -z "$NOBACKUP" ]; then NOBACKUP=0; fi;;
        --restore)
            if [ $# -lt 2 ]; then echo "Option $1 requires an argument"; exit 2; fi
            shift;
            RESTORE=$1;;
        --no-backup)
            NOBACKUP=1;;
        --disable-sandboxing)
            DISABLE_SANDBOXING=1;;
        --no-interaction)
            NO_INTERACTION=1;;
        --backup)
            NOBACKUP=0;;
        --fresh)
            FRESH=1;;
        --help|-h)
            usage; exit 0;;
        *)
            usage; exit 2;;
    esac
    shift
done

EXISTING_OPAM=$(command -v opam || echo)
EXISTING_OPAMV=
if [ -n "$EXISTING_OPAM" ]; then
   EXISTING_OPAMV=$("$EXISTING_OPAM" --version || echo "unknown")
fi

FRESH=${FRESH:-0}

OPAMROOT=${OPAMROOT:-$HOME/.opam}

if [ ! -d "$OPAMROOT" ]; then FRESH=1; fi

if [ -z "$NOBACKUP" ] && [ ! "$FRESH" = 1 ] && [ -z "$RESTORE" ]; then
    case "$EXISTING_OPAMV" in
        2.*) NOBACKUP=1;;
        *) NOBACKUP=0;;
    esac
fi

xsudo() {
    local CMD=$1; shift
    local DST
    for DST in "$@"; do : ; done

    local DSTDIR=$(dirname "$DST")
    if [ ! -w "$DSTDIR" ]; then
        echo "Write access to $DSTDIR required, using 'sudo'."
        echo "Command: $CMD $@"
        if [ "$CMD" = "install" ]; then
            sudo "$CMD" -g 0 -o root "$@"
        else
            sudo "$CMD" "$@"
        fi
    else
        "$CMD" "$@"
    fi
}

if [ -n "$RESTORE" ]; then
    OPAM=$(command -v opam)
    OPAMV=$("$OPAM" --version)
    OPAM_BAK="$OPAM.$RESTORE"
    OPAMROOT_BAK="$OPAMROOT.$RESTORE"
    if [ ! -e "$OPAM_BAK" ] || [ ! -d "$OPAMROOT_BAK" ]; then
        echo "No backup of opam $RESTORE was found"
        exit 1
    fi
    if [ "$NOBACKUP" = 1 ]; then
        printf "## This will clear $OPAM and $OPAMROOT. Continue ? [Y/n] "
        read R
        case "$R" in
            ""|"y"|"Y"|"yes")
                xsudo rm -f "$OPAM"
                rm -rf "$OPAMROOT";;
            *) exit 1
        esac
    else
        xsudo mv "$OPAM" "$OPAM.$OPAMV"
        mv "$OPAMROOT" "$OPAMROOT.$OPAMV"
    fi
    xsudo mv "$OPAM_BAK" "$OPAM"
    mv "$OPAMROOT_BAK" "$OPAMROOT"
    printf "## Opam $RESTORE and its root were restored."
    if [ "$NOBACKUP" = 1 ]; then echo
    else echo " Opam $OPAMV was backed up."
    fi
    exit 0
fi

TMP=${TMPDIR:-/tmp}

ARCH=$(uname -m || echo unknown)
case "$ARCH" in
    x86|i?86) ARCH="i686";;
    x86_64|amd64) ARCH="x86_64";;
    ppc|powerpc|ppcle) ARCH="ppc";;
    aarch64_be|aarch64|armv8b|armv8l) ARCH="arm64";;
    armv5*|armv6*|earmv6*|armv7*|earmv7*) ARCH="armhf";;
    *) ARCH=$(echo "$ARCH" | awk '{print tolower($0)}')
esac

OS=$( (uname -s || echo unknown) | awk '{print tolower($0)}')

if [ "$OS" = "darwin" ] ; then
  OS=macos
fi

TAG=$(echo "$VERSION" | tr '~' '-')

OPAM_BIN_URL_BASE='https://github.com/ocaml/opam/releases/download/'
OPAM_BIN="opam-${TAG}-${ARCH}-${OS}"
OPAM_BIN_URL="${OPAM_BIN_URL_BASE}${TAG}/${OPAM_BIN}"

download() {
    if command -v wget >/dev/null; then wget -q -O "$@"
    else curl -s -L -o "$@"
    fi
}

check_sha512() {
  if command -v openssl > /dev/null; then
    sha512_devnull="cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"
    sha512_check=`openssl sha512 2>&1 < /dev/null | cut -f 2 -d ' '`
    if [ "x$sha512_devnull" = "x$sha512_check" ]; then
      sha512=`openssl sha512 "$TMP/$OPAM_BIN" 2> /dev/null | cut -f 2 -d ' '`
      check=`bin_sha512`
      test "x$sha512" = "x$check"
    else
      echo "openssl 512 option not handled, binary integrity check can't be performed."
      return 0
    fi
  else
    echo "openssl not found, binary integrity check can't be performed."
    return 0
  fi
}

if [ -e "$TMP/$OPAM_BIN" ] && ! check_sha512 || [ ! -e "$TMP/$OPAM_BIN" ]; then
    echo "## Downloading opam $VERSION for $OS on $ARCH..."

    if ! download "$TMP/$OPAM_BIN" "$OPAM_BIN_URL"; then
        echo "There may not yet be a binary release for your architecture or OS, sorry."
        echo "See https://github.com/ocaml/opam/releases/tag/$TAG for pre-compiled binaries,"
        echo "or run 'make cold' from https://github.com/ocaml/opam/archive/$TAG.tar.gz"
        echo "to build from scratch"
        exit 10
    else
        if check_sha512; then
            echo "## Downloaded."
        else
            echo "Checksum mismatch, a problem occurred during download."
            exit 10
        fi
    fi
else
    echo "## Using already downloaded \"$TMP/$OPAM_BIN\""
fi

if [ -n "$EXISTING_OPAM" ]; then
    DEFAULT_BINDIR=$(dirname "$EXISTING_OPAM")
fi

if [ "$NO_INTERACTION" -ne 1 ] ; then
    while true; do
        printf "## Where should it be installed ? [$DEFAULT_BINDIR] "
        read BINDIR
        if [ -z "$BINDIR" ]; then BINDIR="$DEFAULT_BINDIR"; fi

        if [ -d "$BINDIR" ]; then break
        else
            printf "## $BINDIR does not exist. Create ? [Y/n] "
            read R
            case "$R" in
                ""|"y"|"Y"|"yes")
                xsudo mkdir -p $BINDIR
                break;;
            esac
        fi
    done
else 
    BINDIR="$DEFAULT_BINDIR"
fi 

if [ -e "$EXISTING_OPAM" ]; then
    if [ "$NOBACKUP" = 1 ]; then
        xsudo rm -f "$EXISTING_OPAM"
    else
        xsudo mv "$EXISTING_OPAM" "$EXISTING_OPAM.$EXISTING_OPAMV"
        echo "## $EXISTING_OPAM backed up as $(basename $EXISTING_OPAM).$EXISTING_OPAMV"
    fi
fi

if [ -d "$OPAMROOT" ]; then
    if [ "$FRESH" = 1 ]; then
        if [ "$NOBACKUP" = 1 ]; then
            printf "## This will clear $OPAMROOT. Continue ? [Y/n] "
            read R
            case "$R" in
                ""|"y"|"Y"|"yes")
                    rm -rf "$OPAMROOT";;
                *) exit 1
            esac
        else
            mv "$OPAMROOT" "$OPAMROOT.$EXISTING_OPAMV"
            echo "## $OPAMROOT backed up as $(basename $OPAMROOT).$EXISTING_OPAMV"
        fi
        echo "## opam $VERSION installed. Please run 'opam init' to get started"
    elif [ ! "$NOBACKUP" = 1 ]; then
        echo "## Backing up $OPAMROOT to $(basename $OPAMROOT).$EXISTING_OPAMV (this may take a while)"
        if [ -e "$OPAMROOT.$EXISTING_OPAMV" ]; then
            echo "ERROR: there is already a backup at $OPAMROOT.$EXISTING_OPAMV"
            echo "Please move it away or run with --no-backup"
        fi
        FREE=$(df -k "$OPAMROOT" | awk 'NR>1 {print $4}')
        NEEDED=$(du -sk "$OPAMROOT" | awk '{print $1}')
        if ! [ $NEEDED -lt $FREE ]; then
            echo "Error: not enough free space to backup. You can retry with --no-backup,"
            echo "--fresh, or remove '$OPAMROOT'"
            exit 1
        fi
        cp -a "$OPAMROOT" "$OPAMROOT.$EXISTING_OPAMV"
        echo "## $OPAMROOT backed up as $(basename $OPAMROOT).$EXISTING_OPAMV"
    fi
    rm -f "$OPAMROOT"/repo/*/*.tar.gz*
fi

xsudo install -m 755 "$TMP/$OPAM_BIN" "$BINDIR/opam"
echo "## opam $VERSION installed to $BINDIR"

if [ "$DISABLE_SANDBOXING" = 1 ] ; then
    opam init --disable-sandboxing
fi

if [ ! "$FRESH" = 1 ]; then
    echo "## Converting the opam root format & updating"
    "$BINDIR/opam" init --reinit -ni
fi

WHICH=$(command -v opam || echo notfound)

case "$WHICH" in
    "$BINDIR/opam") ;;
    notfound) echo "## Remember to add $BINDIR to your PATH";;
    *)
        echo "## WARNING: 'opam' command found in PATH does not match the installed one:"
        echo "   - Installed: '$BINDIR/opam'"
        echo "   - Found:     '$WHICH'"
        echo "Make sure to remove the second or fix your PATH to use the new opam"
        echo
esac

if [ ! "$NOBACKUP" = 1 ]; then
    echo "## Run this script again with '--restore $EXISTING_OPAMV' to revert."
fi

rm -f $TMP/$OPAM_BIN
