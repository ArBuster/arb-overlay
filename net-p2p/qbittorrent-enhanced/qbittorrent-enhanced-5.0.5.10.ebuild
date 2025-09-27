# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop edo multibuild optfeature systemd xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org"

DESCRIPTION="[Unofficial] qBittorrent Enhanced, based on qBittorrent"
HOMEPAGE="https://github.com/c0re100/qBittorrent-Enhanced-Edition"

SRC_URI="https://github.com/c0re100/qBittorrent-Enhanced-Edition/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="+dbus +gui pbh systemd test webui"
RESTRICT="mirror !test? ( test )"
REQUIRED_USE="
	|| ( gui webui )
	dbus? ( gui )
	pbh? ( webui )
"

RDEPEND="
	!net-p2p/qbittorrent
	>=dev-libs/openssl-3.0.2:=
	>=net-libs/libtorrent-rasterbar-1.2.19:=
	>=sys-libs/zlib-1.2.11
	>=dev-qt/qtbase-6.5:6[network,ssl,sql,sqlite,xml]
	gui? (
		>=dev-qt/qtbase-6.5:6[dbus?,gui,widgets]
		>=dev-qt/qtsvg-6.5:6
	)
	pbh? (
		net-misc/peerbanhelper
		net-analyzer/netcat
	)
	webui? (
		acct-group/qbittorrent
		acct-user/qbittorrent
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/boost-1.76
"
BDEPEND+="
	>=dev-qt/qttools-6.5:6[linguist]
	virtual/pkgconfig
"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

PATCHES=(
	"${FILESDIR}/fix-compile-error-when-disable-webui.patch"
)

S="${WORKDIR}/qBittorrent-Enhanced-Edition-release-${PV}"

src_prepare() {
	MULTIBUILD_VARIANTS=()
	use gui && MULTIBUILD_VARIANTS+=( gui )
	use webui && MULTIBUILD_VARIANTS+=( nogui )

	cmake_src_prepare
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DCMAKE_BUILD_TYPE=Release
			# musl lacks execinfo.h
			-DSTACKTRACE=$(usex !elibc_musl)
			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=ON
			-DWEBUI=$(usex webui)
			-DTESTING=$(usex test)
		)

		if [[ ${MULTIBUILD_VARIANT} == "gui" ]]; then
			# We do this in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			mycmakeargs+=(
				-DGUI=ON
				-DDBUS=$(usex dbus)
				-DSYSTEMD=OFF
			)
		else
			mycmakeargs+=(
				-DGUI=OFF
				-DDBUS=OFF
			)

			use systemd && mycmakeargs+=(
				# The systemd service calls qbittorrent-nox, which is only
				# installed when GUI=OFF.
				-DSYSTEMD=ON
				-DSYSTEMD_SERVICES_INSTALL_DIR="$(systemd_get_systemunitdir)"
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	my_src_test() {
		# cmake does not detect tests by default, if you use enable_testing
		# in a subdirectory instead of the root CMakeLists.txt
		cd "${BUILD_DIR}"/test || die
		edo ctest .
	}

	multibuild_foreach_variant my_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	einstalldocs

	if use gui && use pbh; then
		dobin "${FILESDIR}/qbittorrent-pbh"
		domenu "${FILESDIR}/qbittorrent-pbh.desktop"
	fi

	if use webui; then
		newconfd "${FILESDIR}/${PN}.confd" "${PN}"
		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "I2P anonymyzing network support" net-vpn/i2pd net-vpn/i2p
}
