# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit eutils python-single-r1

DESCRIPTION="Linux file search, instant results as you type"
HOMEPAGE="https://github.com/DoTheEvo/ANGRYsearch"
SRC_URI="https://github.com/DoTheEvo/ANGRYsearch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="notification python_single_target_python3_4 python_single_target_python3_5 python_single_target_python3_6 fm_integration"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '>=dev-python/PyQt5-5.4.1[${PYTHON_USEDEP},gui]' )
	>=app-admin/sudo-1.8.12
	>=x11-libs/libxkbcommon-0.5.0
	>=x11-misc/xdg-utils-1.1.0_rc2"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep 'notification? ( dev-python/pygobject[${PYTHON_USEDEP}] )' )
	fm_integration? ( x11-misc/xdotool )"

DOCS=( README.md )

S="${WORKDIR}/ANGRYsearch-${PV}"

src_prepare() {
    default
	sed -i angrysearch.desktop \
		-e "s:Exec=python3 /usr/share/angrysearch/angrysearch.py:Exec=angrysearch:" \
		|| die

	epatch "${FILESDIR}/${P}.patch"
	eapply_user
}

src_install() {
	insinto /usr/share/${PN}
	doins -r "${S}"/*
	python_fix_shebang "${ED}"usr/share/${PN}/angrysearch*.py
	fperms 0755 /usr/share/${PN}/angrysearch.py
	fperms 0755 /usr/share/${PN}/angrysearch_update_database.py
	dosym /usr/share/${PN}/angrysearch.py /usr/bin/angrysearch
	insinto /usr/share/applications/
	doins angrysearch.desktop
	insinto /usr/share/pixmaps/
	doins angrysearch.svg
}
