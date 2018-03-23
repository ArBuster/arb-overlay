# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
BASE_URI="https://vscode-update.azurewebsites.net/${PV}"
SRC_URI="
	x86? ( ${BASE_URI}/linux-ia32/stable ->  ${P}-x86.tar.gz )
	amd64? ( ${BASE_URI}/linux-x64/stable -> ${P}-amd64.tar.gz )
	"
RESTRICT="mirror strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	x11-libs/libnotify
	dev-libs/nss
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/libXtst
	x11-libs/cairo
	gnome-base/gconf
	app-crypt/libsecret[crypt]
	x11-libs/libxkbfile
	media-libs/fontconfig
"

QA_PRESTRIPPED="opt/${MY_PN}/code"
QA_PREBUILT="opt/${MY_PN}/code"
MY_PN="vscode"

pkg_setup(){
	use amd64 && S="${WORKDIR}/VSCode-linux-x64" || S="${WORKDIR}/VSCode-linux-ia32"
}

src_install(){
	pax-mark m code
	insinto "/opt/${MY_PN}"
	doins -r *
	dosym "/opt/${MY_PN}/bin/code" "/usr/bin/${MY_PN}"
	make_desktop_entry "${MY_PN}" "Visual Studio Code" "${MY_PN}" "Development;IDE"
	doicon ${FILESDIR}/${MY_PN}.png
	fperms +x "/opt/${MY_PN}/code"
	fperms +x "/opt/${MY_PN}/bin/code"
	fperms +x "/opt/${MY_PN}/libnode.so"
	fperms +x "/opt/${MY_PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	insinto "/usr/share/licenses/${MY_PN}"
	newins "resources/app/LICENSE.txt" "LICENSE"
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
