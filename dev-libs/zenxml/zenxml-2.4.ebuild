# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6" 

inherit eutils toolchain-funcs 

MY_P="zenXml" 

DESCRIPTION="Zen XML header C++ library" 
HOMEPAGE="http://zenxml.sourceforge.net/ https://sourceforge.net/projects/zenxml/" 
SRC_URI="mirror://sourceforge/project/zenxml/${MY_P}_${PV}.zip -> ${P}.zip" 

LICENSE="GPL-3" 
SLOT="0" 
KEYWORDS="~amd64 ~x86" 

RDEPEND=""

S="${WORKDIR}"

src_install(){ 
        insinto /usr/include/
        doins -r "${S}/zen/"
        doins -r "${S}/zenxml/"
}
