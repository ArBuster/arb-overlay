# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils git-r3

DESCRIPTION="Simple-obfs is a simple obfusacting tool, designed as plugin server of shadowsocks."
HOMEPAGE="https://github.com/shadowsocks/simple-obfs"
EGIT_REPO_URI="https://github.com/shadowsocks/simple-obfs.git"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

AUTOTOOLS_AUTORECONF=${S}
BUILD_DIR=${S}

src_prepare() {
    autotools-utils_src_prepare 
}
