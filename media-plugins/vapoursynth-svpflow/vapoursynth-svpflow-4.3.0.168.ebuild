# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SVPflow provides fast and high quality GPU accelerated frame rate interpolation."
HOMEPAGE="http://avisynth.nl/index.php/SVPflow"
SRC_URI="https://github.com/ArBuster/vapoursynth-svpflow/releases/download/SVPflow-Backup/svpflow-${PV}.zip -> ${P}.zip"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-util/patchelf
"
RDEPEND="
	media-libs/vapoursynth
	${DEPEND}
"

S="${WORKDIR}/svpflow-${PV}"

src_install() {
	cd lib-linux
	patchelf --clear-execstack libsvpflow1_vs64.so
	newlib.so libsvpflow1_vs64.so libsvpflow1.so
	newlib.so libsvpflow2_vs64.so libsvpflow2.so
}
