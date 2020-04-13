# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="v${PV}"
inherit systemd

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://www.v2ray.com/"
SRC_URI="
	amd64?	( https://github.com/v2ray/v2ray-core/releases/download/$MY_PV/v2ray-linux-64.zip -> v2ray-$PV-linux-64.zip )
	x86?	( https://github.com/v2ray/v2ray-core/releases/download/$MY_PV/v2ray-linux-32.zip -> v2ray-$PV-linux-32.zip )
"
RESTRICT="mirror binchecks"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	dobin v2ray v2ctl

	insinto /etc/v2ray
	doins ${FILESDIR}/{server,client}.conf

	systemd_dounit "${FILESDIR}/v2ray@.service"
}

pkg_postinst() {
    ewarn "Configuration files path: /etc/v2ray"
    ewarn "Using systemctl start v2ray@{server or client}.service to start service"
}
