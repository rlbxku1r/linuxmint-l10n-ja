#!/usr/bin/env fish

if test $EUID -ne 0
    echo "$(status basename): This script must be run as root." >&2
    exit 1
end

set CATALOG_DIR (status dirname)
set CATALOG_LANG (cat $CATALOG_DIR/.catalog_lang)

function generate_mo -a PO MO
    msgfmt -o $MO $PO
    chown root:root $MO
    chmod a=r,u+w $MO
    echo $MO
end

# /usr/share/locale/$CATALOG_LANG/LC_MESSAGES/*.mo
set CATALOGS \
    aptkit \
    bulky \
    captain \
    cinnamon-control-center \
    cinnamon-screensaver \
    cinnamon-session \
    cinnamon-settings-daemon \
    cinnamon \
    fingwit \
    folder-color-switcher \
    hypnotix \
    lightdm-settings \
    mintdrivers \
    mintreport \
    mintsysadm \
    mintupdate \
    mintupgrade \
    nemo \
    nemo-extensions \
    nvidia-prime-applet \
    pix \
    python-xapp \
    slick-greeter \
    sticky \
    thingy \
    timeshift \
    warpinator \
    webapp-manager \
    xapp \
    xreader \
    xviewer

for CATALOG in $CATALOGS
    generate_mo $CATALOG_DIR/{$CATALOG}_$CATALOG-$CATALOG_LANG.po /usr/share/locale/$CATALOG_LANG/LC_MESSAGES/$CATALOG.mo
end

generate_mo $CATALOG_DIR/xedit_xed-$CATALOG_LANG.po /usr/share/locale/$CATALOG_LANG/LC_MESSAGES/xed.mo

# /usr/share/linuxmint/locale/$CATALOG_LANG/LC_MESSAGES/*.mo
set CATALOGS \
    mint-common \
    mintbackup \
    mintdesktop \
    mintinstall \
    mintlocale \
    mintmenu \
    mintnanny \
    mintsources \
    mintstick \
    mintupload \
    mintwelcome

for CATALOG in $CATALOGS
    generate_mo $CATALOG_DIR/{$CATALOG}_$CATALOG-$CATALOG_LANG.po /usr/share/linuxmint/locale/$CATALOG_LANG/LC_MESSAGES/$CATALOG.mo
end

exit 0
