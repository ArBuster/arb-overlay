# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="KMS Emulator in C"
HOMEPAGE="https://github.com/Wind4/vlmcsd"
SRC_URI="https://github.com/Wind4/vlmcsd/archive/refs/tags/svn${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}/${PN}-svn${PV}"

src_compile() {
	emake "CFLAGS=${CFLAGS}"
	emake "CFLAGS=${CFLAGS} man"
}

src_install() {
	dobin ${S}/bin/vlmcs*
	doman ${S}/man/vlmcs*
	insinto /etc/vlmcsd
	doins ${S}/etc/*
	systemd_dounit "${FILESDIR}/${PN}.service"
}
