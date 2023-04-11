# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps systemd toolchain-funcs

DESCRIPTION="A Tunnel which Improves your Network Quality on a High-latency Lossy Link by using Forward Error Correction,for All Traffics(TCP/UDP/ICMP)"
HOMEPAGE="https://github.com/wangyu-/UDPspeeder"
SRC_URI="https://codeload.github.com/wangyu-/UDPspeeder/tar.gz/${PV} -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/UDPspeeder-${PV}"

src_prepare() {
    default

	# Disable optimisation flags and remove prefixes of exec files
	sed -e "s/\s\+-O[0-3a-z]//g" \
        -e "s/\s\+-static//g" \
		-e "s/\${NAME}_[a-zA-Z0-9\$@]*/\${NAME}/g" \
		-e "s/\${cc_[a-zA-Z0-9_]*}/$(tc-getCXX)/g" \
		-i makefile
}

src_compile() {
	emake OPT="${CXXFLAGS}" \
		$(use amd64 && echo amd64) \
		$(use x86 && echo x86)
}

src_install() {
	newbin speederv2 ${PN}
	
	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	fcaps cap_net_bind_service /usr/bin/${PN}
}
