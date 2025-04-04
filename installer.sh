#!/bin/sh
# #########################
# Command: wget https://raw.githubusercontent.com/emil237/ansite/refs/heads/main/installer.sh -qO - | /bin/sh
##################
# SCRIPT : DOWNLOAD AND INSTALL ANSITE
# ###########################################

TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-ansite'
MY_URL='https://raw.githubusercontent.com/emil237/ansite/refs/heads/main'
PYTHON_VERSION=$(python -c "import sys; print(sys.version_info[0])" 2>/dev/null)

# Check if opkg is available
if [ ! -f /etc/opkg/opkg.conf ]; then
    echo "Error: opkg package manager not found!"
    exit 1
fi

OPKG="opkg update"
OPKGINSTAL="opkg install --force-reinstall --force-depends"
OPKGLIST="opkg list-installed"
OPKGREMOV="opkg remove --force-depends --force-remove"

echo "Detected Python$PYTHON_VERSION image..."
sleep 1

# Cleanup previous files
rm -rf "$TMPDIR/${PACKAGE:?}"* >/dev/null 2>&1

# Check if already installed
INSTALLED=$($OPKGLIST | grep "$PACKAGE")
if [ -n "$INSTALLED" ]; then
    echo "Removing existing version of $PACKAGE..."
    $OPKGREMOV "$PACKAGE" >/dev/null 2>&1 || {
        echo "Failed to remove existing version!"
        exit 1
    }
fi

echo "Updating package lists..."
$OPKG >/dev/null 2>&1 || {
    echo "Failed to update package lists!"
    exit 1
}

echo "Installing Ansite plugin..."
if [ "$PYTHON_VERSION" = "3" ]; then
    PKG_FILE="enigma2-plugin-extensions-ansite_1.10.py3_all.ipk"
else
    PKG_FILE="enigma2-plugin-extensions-ansite_1.5_py2_all.ipk"
fi

wget "$MY_URL/$PKG_FILE" -qP "$TMPDIR" || {
    echo "Failed to download package!"
    exit 1
}

$OPKGINSTAL "$TMPDIR/$PKG_FILE" || {
    echo "Installation failed!"
    exit 1
}

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



