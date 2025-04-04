#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL ANSITE
# ###########################################

TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-ansite'
MY_URL='https://raw.githubusercontent.com/emil237/ansite/main'
PYTHON_VERSION=$(python -c "import sys; print(sys.version_info.major)" 2>/dev/null || python -c "import sys; print(sys.version_info[0])")

[ -f /etc/opkg/opkg.conf ] && {
    OPKG='opkg update'
    OPKGINSTAL='opkg install --force-reinstall --force-depends'
    OPKGLIST='opkg list-installed'
    OPKGREMOV='opkg remove --force-depends --force-remove'
}

echo "Detected Python$PYTHON_VERSION image..."
sleep 1
clear

rm -rf "$TMPDIR/${PACKAGE:?}"* >/dev/null 2>&1

if INSTALLED_VERSION=$($OPKGLIST $PACKAGE 2>/dev/null | awk '{ print $3 }'); then
    if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
        echo "Latest version $VERSION already installed"
        exit 0
    else
        echo "Removing existing version ($INSTALLED_VERSION)..."
        $OPKGREMOV $PACKAGE >/dev/null 2>&1
    fi
fi

echo "Updating package lists..."
$OPKG >/dev/null 2>&1

echo "Installing Ansite plugin..."
PKG_FILE="enigma2-plugin-extensions-ansite_$(if [ "$PYTHON_VERSION" -eq 3 ]; then echo "1.10.py3_all.ipk"; else echo "1.5_py2_all.ipk"; fi)"
wget "$MY_URL/$PKG_FILE" -qP "$TMPDIR" && $OPKGINSTAL "$TMPDIR/$PKG_FILE"

rm -rf "$TMPDIR/${PACKAGE:?}"* >/dev/null 2>&1

cat <<EOF

***********************************************************************
**                                                                   **
**   >>>>>>>>>>  Uploaded by: EMIL_NABiL                     **
**                       Developed by: aime_jeux                      **
**                                                                   **
***********************************************************************

EOF
exit 0
