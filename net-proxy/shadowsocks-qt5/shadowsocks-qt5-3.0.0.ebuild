# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Shadowsocks-Qt5 is a native and cross-platform shadowsocks GUI client with advanced features"
HOMEPAGE="https://github.com/shadowsocks/shadowsocks-qt5"
SRC_URI="https://github.com/shadowsocks/shadowsocks-qt5/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-qt/qtcore-5.5
	media-gfx/qrencode
	media-gfx/zbar
	dev-libs/libappindicator
	net-proxy/libqtshadowsocks:2
	"
RDEPEND="${DEPEND}"

pkg_postinst() {
	kde5_pkg_postinst
}

pkg_postrm() {
	kde5_pkg_postrm
}
