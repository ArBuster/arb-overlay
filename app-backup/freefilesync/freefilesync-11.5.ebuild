# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="https://www.freefilesync.org"
SRC_URI="https://freefilesync.org/download/FreeFileSync_${PV}_Linux.tar.gz"
RESTRICT="fetch"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="
        app-accessibility/at-spi2-core
        dev-libs/expat
        dev-libs/glib
        media-libs/fontconfig
        media-libs/freetype
        x11-libs/cairo
        x11-libs/gdk-pixbuf
        x11-libs/gtk+:2
        x11-libs/libSM
        x11-libs/libX11
        x11-libs/pango
        "

S=${WORKDIR}
MY_PN="FreeFileSync"
FFS_PN="freefilesync"
RTS_PN="realtimesync"

src_install(){
    insinto "/opt"
    doins -r *
    dosym "/opt/${MY_PN}/FreeFileSync" "/usr/bin/${FFS_PN}"
    dosym "/opt/${MY_PN}/RealTimeSync" "/usr/bin/${RTS_PN}"

    #fperms 777 "/opt/${MY_PN}"

    fperms +x "/opt/${MY_PN}/FreeFileSync"
    fperms +x "/opt/${MY_PN}/RealTimeSync"
    fperms +x "/opt/${MY_PN}/Bin/FreeFileSync_x86_64"
    fperms +x "/opt/${MY_PN}/Bin/RealTimeSync_x86_64"
    #fperms +x "/opt/${MY_PN}/Bin/FreeFileSync_i686"
    #fperms +x "/opt/${MY_PN}/Bin/RealTimeSync_i686"

    make_desktop_entry "${FFS_PN}" "FreeFileSync" "FreeFileSync" "Utility;Archiving" "GenericName=File synchronization tool"
    #doicon "${FILESDIR}/FreeFileSync.png"
    doicon "${S}/${MY_PN}/Resources/FreeFileSync.png"

    make_desktop_entry "${RTS_PN}" "RealTimeSync" "RealTimeSync" "Utility;Archiving" "GenericName=Real time file synchronization tool"
    #doicon "${FILESDIR}/RealTimeSync.png"
    doicon "${S}/${MY_PN}/Resources/RealTimeSync.png"
}
