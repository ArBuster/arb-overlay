# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="yEd Graph Editor - High-quality diagrams made easy"
HOMEPAGE="https://www.yworks.com/products/yed"
SRC_URI="https://www.yworks.com/resources/yed/demo/yEd-${PV}.zip -> ${P}.zip"
RESTRICT="mirror"

LICENSE="yEd"

SLOT="0"
KEYWORDS="amd64"

IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

src_install(){
    insinto "/opt/${PN}"
    doins -r *

    make_desktop_entry "java -Dsun.java2d.uiScale=2 -jar /opt/${PN}/yed.jar" "yEd Graph Editor" "yed" "Graphics;2DGraphics"
    newicon "${S}/icons/yed128.png" "yed.png"
}
