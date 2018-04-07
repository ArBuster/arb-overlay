# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

MY_P="burpsuite_free_v${PV}.jar"

DESCRIPTION="Interactive proxy for attacking and debugging web applications"
HOMEPAGE="https://portswigger.net/burp/"
SRC_URI="https://portswigger.net/burp/releases/download?product=community&version=${PV}&type=jar -> ${MY_P}"

LICENSE="BURP"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="|| ( virtual/jre virtual/jdk )"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}"
}

src_install() {
	dodir /opt/"${PN}"
	insinto /opt/"${PN}"
	doins "${MY_P}"

	echo -e "#!/bin/sh\njava -jar /opt/${PN}/${MY_P} >/dev/null 2>&1 &\n" > "${PN}"
	dobin ${PN}
	make_desktop_entry "${PN}" "Burp Suite Community Edition" "${PN}" "Network;WebDevelopment"
	doicon ${FILESDIR}/${PN}.png
}
