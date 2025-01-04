# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps systemd go-module

go-module_set_globals GOPROXY="sock5://[::]:30000"

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://www.v2ray.com/"
SRC_URI="https://github.com/v2fly/v2ray-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
#https://raw.githubusercontent.com/ArBuster/arb-overlay/refs/heads/master/net-proxy/v2ray/files/${P}-vendor.tar.xz

RESTRICT="mirror binchecks strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
dev-lang/go
net-misc/v2ray-rules-dat
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/v2ray-core-${PV}"

src_unpack() {
	unpack ${P}.tar.gz
	unpack ${FILESDIR}/${P}-vendor.tar.xz
}

src_compile() {
	echo "replace gvisor.dev/gvisor v0.0.0-20231020174304-b8a429915ff1 => ../gvisor-b8a429915ff1a5747ed6608bd30cd3a734eb6aaf" >> go.mod
    #CGO_ENABLED=0 ego build -o ./v2ray -trimpath -ldflags "-s -w -buildid=" ./main
    ego build -o ./v2ray -trimpath -ldflags "-s -w -buildid=" ./main
}

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
