# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="https://www.freefilesync.org"
SRC_URI="https://download1656.mediafire.com/ribj2zsdiclg/b1nuw6itcet8jzb/FreeFileSync_${PV}_Linux_64-bit.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

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
    make_desktop_entry "${FFS_PN}" "FreeFileSync" "FreeFileSync" "Utility;Archiving" "GenericName=File synchronization tool"
    doicon "${FILESDIR}/FreeFileSync.png"
    make_desktop_entry "${RTS_PN}" "RealTimeSync" "RealTimeSync" "Utility;Archiving" "GenericName=Real time file synchronization tool"
    doicon "${FILESDIR}/RealTimeSync.png"
}
