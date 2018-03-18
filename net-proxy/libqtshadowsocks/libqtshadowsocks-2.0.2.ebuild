# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A lightweight and ultra-fast shadowsocks library written in C++14 with Qt framework"
HOMEPAGE="https://github.com/shadowsocks/libQtShadowsocks"
SRC_URI="https://github.com/shadowsocks/libQtShadowsocks/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LGPL-3"
SLOT="2"
KEYWORDS="~amd64"

DEPEND=">=dev-qt/qtcore-5.5
	>=dev-libs/botan-2.3.0
	>=sys-devel/gcc-4.9[cxx]
	"
RDEPEND="${DEPEND}"

RL_PN="libQtShadowsocks"
S="${WORKDIR}/${RL_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		"-DLIB_INSTALL_DIR=/usr/$(get_libdir)"
		"-DUSE_BOTAN2=ON"
	)
	cmake-utils_src_configure
}
