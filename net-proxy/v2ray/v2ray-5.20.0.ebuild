# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps systemd

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://www.v2ray.com/"
SRC_URI="
	amd64?	( https://github.com/v2fly/v2ray-core/releases/download/v${PV}/v2ray-linux-64.zip -> ${P}-linux-64.zip )
"
RESTRICT="mirror binchecks strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="net-misc/v2ray-rules-dat"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	dobin v2ray

	insinto /etc/v2ray
	doins ${FILESDIR}/{server,client}.conf

	systemd_dounit "${FILESDIR}/v2ray@.service"
}

pkg_postinst() {
	fcaps cap_net_bind_service,cap_net_admin /usr/bin/${PN}
    ewarn "Configuration files path: /etc/v2ray"
    ewarn "Using systemctl start v2ray@{server or client}.service to start service"
}
