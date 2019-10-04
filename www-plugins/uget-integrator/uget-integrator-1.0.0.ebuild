# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Native messaging host to integrate uGet Download Manager with web browsers"
HOMEPAGE="https://github.com/ugetdm/${PN}"
SRC_URI="https://github.com/ugetdm/${PN}/archive/v${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="chrome +chromium +firefox opera"

RDEPEND="
    www-client/uget
"

src_prepare() {
    epatch "${FILESDIR}/filename.patch"
	eapply_user
}

src_install(){
    dobin "bin/uget-integrator"
    
    if use chrome; then
        insinto "/etc/opt/chrome/native-messaging-hosts"
        doins "conf/com.ugetdm.chrome.json"
    fi
    
    if use chromium; then
        insinto "/etc/chromium/native-messaging-hosts"
        doins "conf/com.ugetdm.chrome.json"
    fi
    
    if use firefox; then
        insinto "/usr/lib/mozilla/native-messaging-hosts"
        doins "conf/com.ugetdm.firefox.json"
    fi
    
    if use opera; then
        insinto "/etc/opera/native-messaging-hosts"
        doins "conf/com.ugetdm.chrome.json"
    fi
}
