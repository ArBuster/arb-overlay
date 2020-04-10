# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="https://vscode-update.azurewebsites.net/${PV}/linux-x64/stable -> ${P}-amd64.tar.gz"
RESTRICT="mirror strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	x11-libs/libnotify
	dev-libs/nss
	>=x11-libs/gtk+-3.10.0:3
	app-crypt/libsecret[crypt]
	x11-libs/libxkbfile
	x11-libs/libXScrnSaver
"

QA_PRESTRIPPED="opt/${PN}/code"
QA_PREBUILT="opt/${PN}/code"

S="${WORKDIR}/VSCode-linux-x64"

src_install(){
	pax-mark m code
	insinto "/opt/${PN}"
	doins -r *
	dosym "/opt/${PN}/bin/code" "/usr/bin/${PN}"
	make_desktop_entry "${PN}" "Visual Studio Code" "${PN}" "Development;IDE"
	doicon ${FILESDIR}/${PN}.png
	
	fperms +x "/opt/${PN}/chrome-sandbox"
	fperms +x "/opt/${PN}/code"
	fperms +x "/opt/${PN}/libEGL.so"
	fperms +x "/opt/${PN}/libffmpeg.so"
	fperms +x "/opt/${PN}/libGLESv2.so"
	fperms +x "/opt/${PN}/bin/code"
	fperms +x "/opt/${PN}/swiftshader/libEGL.so"
	fperms +x "/opt/${PN}/swiftshader/libGLESv2.so"
	fperms +x "/opt/${PN}/swiftshader/libvk_swiftshader.so"
	fperms +x "/opt/${PN}/resources/app/extensions/git/dist/askpass.sh"
	fperms +x "/opt/${PN}/resources/app/extensions/git/dist/askpass-empty.sh"
	fperms +x "/opt/${PN}/resources/app/extensions/ms-vscode.node-debug2/node_modules/mkdirp/bin/cmd.js"
	fperms +x "/opt/${PN}/resources/app/extensions/ms-vscode.node-debug2/out/src/terminateProcess.sh"
	fperms +x "/opt/${PN}/resources/app/extensions/ms-vscode.node-debug2/src/terminateProcess.sh"
	fperms +x "/opt/${PN}/resources/app/extensions/node_modules/typescript/bin/tsserver"
	fperms +x "/opt/${PN}/resources/app/extensions/node_modules/typescript/bin/tsc"
	fperms +x "/opt/${PN}/resources/app/extensions/ms-vscode.node-debug/dist/terminateProcess.sh"
	fperms +x "/opt/${PN}/resources/app/out/vs/base/node/ps.sh"
	fperms +x "/opt/${PN}/resources/app/out/vs/base/node/terminateProcess.sh"
	fperms +x "/opt/${PN}/resources/app/out/vs/base/node/cpuUsage.sh"
	fperms +x "/opt/${PN}/resources/app/out/vs/workbench/browser/parts/editor/media/letterpress-hc.svg"
	fperms +x "/opt/${PN}/resources/app/out/vs/workbench/browser/parts/editor/media/letterpress-dark.svg"
	fperms +x "/opt/${PN}/resources/app/out/vs/workbench/browser/parts/editor/media/letterpress.svg"
	fperms +x "/opt/${PN}/resources/app/out/vs/workbench/contrib/update/browser/media/code-icon.svg"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/native-is-elevated/build/Release/iselevated.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/node-pty/build/Release/pty.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/oniguruma/build/Release/onig_scanner.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-nsfw/build/Release/nsfw.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-nsfw/build/Release/obj.target/nsfw.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/native-watchdog/build/Release/watchdog.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-sqlite3/build/Release/sqlite.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/native-keymap/build/Release/keymapping.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/spdlog/build/Release/spdlog.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/keytar/build/Release/keytar.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/keytar/build/Release/obj.target/keytar.node"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vsda/build/Release/vsda.node"
}
