# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop

DESCRIPTION="Agile visual data modeling for JSON, NoSQL, and multimodel databases"
HOMEPAGE="https://hackolade.com"
SRC_URI="amd64? ( https://s3-eu-west-1.amazonaws.com/hackolade/current/Hackolade-linux-x64.zip -> ${PN}.zip )"
RESTRICT="mirror"

LICENSE="Hackolade"

SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/linux-x64/Hackolade-linux-x64"
MY_PN="Hackolade"

src_install(){
    insinto "/opt/${MY_PN}"
    doins -r *
    dosym "/opt/${MY_PN}/${MY_PN}" "/usr/bin/${PN}"
    fperms +x "/opt/${MY_PN}/${MY_PN}"
    make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}" "Development;IDE" "GenericName=Data modeling for multimodel databases"
    doicon "${FILESDIR}/${MY_PN}.png"
}
