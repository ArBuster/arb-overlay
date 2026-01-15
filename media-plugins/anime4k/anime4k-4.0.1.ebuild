# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A High-Quality Real Time Upscaler for Anime Video"
HOMEPAGE="https://github.com/bloc97/Anime4K"
SRC_URI="https://github.com/bloc97/Anime4K/releases/download/v${PV}/Anime4K_v4.0.zip -> ${P}.zip"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="
	>=media-video/mpv-0.34.0
	${DEPEND}
"

S=${WORKDIR}

src_install() {
	insinto /usr/share/${PN}
	doins *
	insinto /etc/mpv
	doins ${FILESDIR}/mpv_conf/*
}
