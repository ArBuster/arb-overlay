# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps systemd

DESCRIPTION="Xray, Penetrates Everything. Also the best v2ray-core, with XTLS support. Fully compatible configuration."
HOMEPAGE="https://github.com/xtls/xray-core"
SRC_URI="
	amd64?	( https://github.com/XTLS/Xray-core/releases/download/v${PV}/Xray-linux-64.zip -> ${P}-linux-64.zip )
"
RESTRICT="mirror binchecks strip"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	dobin xray

	insinto /usr/share/xray
	doins geo*.dat

	insinto /etc/xray
	doins ${FILESDIR}/{server,client}.conf

	systemd_dounit "${FILESDIR}/xray@.service"
}

pkg_postinst() {
	fcaps cap_net_raw,cap_net_bind_service /usr/bin/${PN}
    ewarn "Configuration files path: /etc/xray"
    ewarn "Using systemctl start xray@{server or client}.service to start service"
}
