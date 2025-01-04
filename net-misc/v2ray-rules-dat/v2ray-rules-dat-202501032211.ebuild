# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="V2Ray路由规则文件加强版."
HOMEPAGE="https://github.com/Loyalsoldier/v2ray-rules-dat"
SRC_URI="
https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${PV}/geoip.dat -> v2ray-geoip-${PV}.dat
https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${PV}/geosite.dat -> v2ray-geosite-${PV}.dat
"
RESTRICT="mirror binchecks strip"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${DISTDIR}

src_install() {
	insinto /usr/share/v2ray
	newins v2ray-geoip-${PV}.dat geoip.dat
	newins v2ray-geosite-${PV}.dat geosite.dat
}
