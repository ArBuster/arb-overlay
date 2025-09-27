# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Automatically block unwanted, leeches and abnormal BT peers with support for customized and cloud rules."
HOMEPAGE="https://github.com/PBH-BTN/PeerBanHelper"
SRC_URI="https://github.com/PBH-BTN/PeerBanHelper/releases/download/v${PV}/PeerBanHelper_${PV}.zip -> ${P}.zip"
RESTRICT="mirror"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="amd64"

IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-21"

S="${WORKDIR}/PeerBanHelper"

src_install(){
    insinto "/opt/${PN}"
    doins -r *

    doins "${FILESDIR}/peerbanhelper.py"
    fperms +x "/opt/${PN}/peerbanhelper.py"
    dosym "/opt/${PN}/peerbanhelper.py" "/usr/bin/peerbanhelper"

    insinto "/etc/peerbanhelper"
	doins ${FILESDIR}/{config,profile}.yml
	systemd_douserunit "${FILESDIR}/peerbanhelper.service"
}
