# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION="A ready-to-use zsh configuration with plugins"
HOMEPAGE="https://github.com/robbyrussell/oh-my-zsh"
EGIT_REPO_URI="https://github.com/robbyrussell/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-shells/zsh"
RDEPEND="${DEPEND}"

ZSH_DEST="/usr/share/${PN}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add to your ~/.zshrc \n
source '${ZSH_DEST}/${ZSH_TEMPLATE}' \n
or copy a modification of that file to your ~/.zshrc \n
If you just want to try, enter the above command in your zsh."

src_prepare() {
    sed -i 's:$HOME/.oh-my-zsh:'${ZSH_DEST}':g' "${S}/${ZSH_TEMPLATE}"
}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
}

pkg_postinst() {
	ewarn ${DOC_CONTENTS}
}
