#!/usr/bin/env fish

if test $EUID -ne 0
    echo "$(status basename): This script must be run as root." >&2
    exit 1
end

set CATALOG_DIR (status dirname)
set CATALOG_LANG (cat $CATALOG_DIR/.catalog_lang)

function generate_mo -a po mo
    msgfmt -o $mo $po
    chown root:root $mo
    chmod a=r,u+w $mo
    echo $mo
end

function po_name -a catalog
    # If the $catalog contains an underscore, use it as a prefix as is.
    # Otherwise, make a prefix that repeats the $catalog twice, separated by an underscore.
    if string match -q '*_*' $catalog
        # e.g. "xedit_xed" becomes "xedit_xed-$CATALOG_LANG.po".
        echo $catalog-$CATALOG_LANG.po
    else
        # e.g. "cinnamon" becomes "cinnamon_cinnamon-$CATALOG_LANG.po".
        echo "$catalog"_$catalog-$CATALOG_LANG.po
    end
end

function mo_name -a catalog
    # If the $catalog is separated by underscores, print its last word. Otherwise, just print it as is.
    # e.g. "xedit_xed" becomes "xed.mo", and "cinnamon" becomes "cinnamon.mo".
    echo (string split _ $catalog | tail -n1).mo
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

for catalog in $CATALOGS
    generate_mo $CATALOG_DIR/(po_name $catalog) /usr/share/locale/$CATALOG_LANG/LC_MESSAGES/(mo_name $catalog)
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

for catalog in $CATALOGS
    generate_mo $CATALOG_DIR/(po_name $catalog) /usr/share/linuxmint/locale/$CATALOG_LANG/LC_MESSAGES/(mo_name $catalog)
end

exit 0
