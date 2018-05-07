# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="mnmlstc"

DESCRIPTION="C++14 (and beyond) library features implemented in C++11"
HOMEPAGE="https://github.com/mnmlstc/core"
SRC_URI="https://github.com/${MY_PN}/core/releases/download/v${PV}/core-${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_DIR="core-${PV}"
S="${WORKDIR}/${SRC_DIR}"

src_install(){
    doheader -r "${S}/include/core"
    dodoc -r "${S}/share/doc/mnmlstc/core"
    insinto "/usr/share/cmake"
    doins -r "${S}/share/cmake/core"
}
