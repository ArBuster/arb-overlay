# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps systemd toolchain-funcs

DESCRIPTION="A tunnel which turns UDP traffic into encrypted FakeTCP/UDP/ICMP traffic"
HOMEPAGE="https://github.com/wangyu-/udp2raw-tunnel"
SRC_URI="https://codeload.github.com/wangyu-/udp2raw-tunnel/tar.gz/${PV} -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cpu_flags_x86_aes"

DEPEND=""
RDEPEND="${DEPEND}
    net-firewall/iptables
    "

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
		$(use cpu_flags_x86_aes && use amd64 && echo amd64_hw_aes) \
		$(use cpu_flags_x86_aes && use x86 && echo x86_asm_aes)
}

src_install() {
	insinto "/etc/${PN}"
	newins example.conf ${PN}.conf
	
	newbin udp2raw ${PN}
	
	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	fcaps cap_net_raw,cap_net_bind_service /usr/bin/${PN}
}
