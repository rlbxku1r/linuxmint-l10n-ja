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

function po_name -a CATALOG
    # If the $CATALOG contains an underscore, use it as a prefix as is.
    # Otherwise, make a prefix that repeats the $CATALOG twice, separated by an underscore.
    if string match -q '*_*' $CATALOG
        # e.g. "xedit_xed" becomes "xedit_xed-$CATALOG_LANG.po".
        echo $CATALOG-$CATALOG_LANG.po
    else
        # e.g. "cinnamon" becomes "cinnamon_cinnamon-$CATALOG_LANG.po".
        echo "$CATALOG"_$CATALOG-$CATALOG_LANG.po
    end
end

function mo_name -a CATALOG
    # If the $CATALOG is separated by underscores, print its last word. Otherwise, just print it as is.
    # e.g. "xedit_xed" becomes "xed.mo", and "cinnamon" becomes "cinnamon.mo".
    echo (string split _ $CATALOG | tail -n1).mo
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
    xedit_xed \
    xreader \
    xviewer

for CATALOG in $CATALOGS
    generate_mo $CATALOG_DIR/(po_name $CATALOG) /usr/share/locale/$CATALOG_LANG/LC_MESSAGES/(mo_name $CATALOG)
end

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
    generate_mo $CATALOG_DIR/(po_name $CATALOG) /usr/share/linuxmint/locale/$CATALOG_LANG/LC_MESSAGES/(mo_name $CATALOG)
end

exit 0
