#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL ANSITE
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/emil237/ansite/main/installer.sh -qO - | /bin/sh
#
# ###########################################

TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-ansite'
MY_URL='https://raw.githubusercontent.com/emil237/ansite/main'
PYTHON_VERSION=$(python -c "import sys; print(sys.version_info.major)" 2>/dev/null || python -c "import sys; print(sys.version_info[0])")

if [ -f /etc/opkg/opkg.conf ]; then
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGLIST='opkg list-installed'
    OPKGREMOV='opkg remove --force-depends'
fi

if [ "$PYTHON_VERSION" -eq 3 ]; then
    echo "You have Python3 image..."
    sleep 1
    clear
else
    echo "You have Python2 image..."
    sleep 1
    clear
fi

rm -rf "$TMPDIR/${PACKAGE:?}"* >/dev/null 2>&1

INSTALLED_VERSION=$($OPKGLIST $PACKAGE 2>/dev/null | awk '{ print $3 }')

if [ -n "$INSTALLED_VERSION" ]; then
    if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
        echo "You are using the latest version: $VERSION"
        exit 1
    else
        echo "Removing previous version ($INSTALLED_VERSION)..."
        $OPKGREMOV $PACKAGE
    fi
fi

echo "Updating package lists..."
$OPKG >/dev/null 2>&1

echo "Installing Ansite plugin. Please Wait..."
if [ "$PYTHON_VERSION" -eq 3 ]; then
    wget "$MY_URL/enigma2-plugin-extensions-ansite_1.10.py3_all.ipk" -qP "$TMPDIR"
    $OPKGINSTAL "$TMPDIR/enigma2-plugin-extensions-ansite_1.10.py3_all.ipk"
else
    wget "$MY_URL/enigma2-plugin-extensions-ansite_1.5_py2_all.ipk" -qP "$TMPDIR"
    $OPKGINSTAL "$TMPDIR/enigma2-plugin-extensions-ansite_1.5_py2_all.ipk"
fi

rm -rf "$TMPDIR/${PACKAGE:?}"* >/dev/null 2>&1

sleep 2
echo ""
echo "***********************************************************************"
echo "**                                                                    *"      
echo "**   >>>>>>>>>>  Uploaded by: EMIL_NABiL                     *"
echo "**                       Developed by: aime_jeux                      *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""
exit 0
