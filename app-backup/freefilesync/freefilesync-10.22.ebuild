# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="https://www.freefilesync.org"
SRC_URI="https://freefilesync.org/download/FreeFileSync_${PV}_Linux.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=x11-libs/wxGTK-3.0.3:3.0[X]
    dev-libs/boost
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
    fperms 777 "/opt/${MY_PN}"
    fperms +x "/opt/${MY_PN}/FreeFileSync"
    fperms +x "/opt/${MY_PN}/RealTimeSync"
    fperms +x "/opt/${MY_PN}/Bin/FreeFileSync_i686"
    fperms +x "/opt/${MY_PN}/Bin/FreeFileSync_x86_64"
    fperms +x "/opt/${MY_PN}/Bin/RealTimeSync_i686"
    fperms +x "/opt/${MY_PN}/Bin/RealTimeSync_x86_64"
    make_desktop_entry "${FFS_PN}" "FreeFileSync" "FreeFileSync" "Utility;Archiving" "GenericName=File synchronization tool"
    doicon "${FILESDIR}/FreeFileSync.png"
    make_desktop_entry "${RTS_PN}" "RealTimeSync" "RealTimeSync" "Utility;Archiving" "GenericName=Real time file synchronization tool"
    doicon "${FILESDIR}/RealTimeSync.png"
}
