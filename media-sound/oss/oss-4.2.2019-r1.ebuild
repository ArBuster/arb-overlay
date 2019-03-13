# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator linux-mod systemd

MY_P="oss-v$(get_version_component_range 1-2)-build$(get_version_component_range 3)-src-gpl"

DESCRIPTION="Open Sound System - portable, mixing-capable, high quality sound system for Unix"
HOMEPAGE="http://developer.opensound.com"
SRC_URI="http://www.4front-tech.com/developer/sources/stable/gpl/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPRECATED_CARDS="allegro als3xx als4k digi32 maestro neomagic s3vibes vortex"

CARDS="ali5455 atiaudio audigyls audiocs audioloop audiopci cmi878x cmpci cs4281 cs461x
	digi96 emu10k1x envy24 envy24ht fmedia geode hdaudio ich imux madi midiloop
	midimix sblive sbpci sbxfi solo trident usb userdev via823x via97 ymf7xx
	${DEPRECATED_CARDS}"

IUSE="+alsa +gtk midi ogg vmix_fixedpoint"

for card in ${CARDS} ; do
	IUSE+=" oss_cards_${card}"
done

DEPEND="alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	ogg? ( media-libs/libvorbis )
	sys-apps/gawk
	sys-kernel/linux-headers
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	
	mkdir "${WORKDIR}/build"

	cp "${FILESDIR}/oss.init" "${S}/setup/Linux/oss/etc/S89oss"
	
	if ! use ogg ; then
		sed -e "s;OGG_SUPPORT=YES;OGG_SUPPORT=NO;g" \
			-i "${S}/configure"
	fi

	for deprecated_card in ${DEPRECATED_CARDS} ; do
		ln -s "${S}/attic/drv/oss_${deprecated_card}" "${S}/kernel/drv/oss_${deprecated_card}"
	done

	sed -e "s/-Werror//g" \
		-i "${S}/phpmake/Makefile.php" \
		-i "${S}/setup/Linux/oss/build/install.sh"

	#enable "production quality"
	sed -e "s;GRC_MAX_QUALITY=3;GRC_MAX_QUALITY=6;g" \
		-i "${S}/configure"

	# Build at the "build" directory instead of /tmp
	sed -e "s;/tmp/;${WORKDIR}/build/;g" \
		-i "${S}/setup/Linux/build.sh"

	# Remove bundled libflashsupport. Deprecated since 2006.
	rm ${S}/oss/lib/flashsupport.c
	sed -e "/^.*flashsupport.c .*/d" \
		-i "${S}/setup/Linux/build.sh" \
		-i "${S}/setup/Linux/oss/build/install.sh"
		
    epatch \
		"${FILESDIR}/${PF}-linux-4.14.patch"

	eapply_user
}

src_configure() {
	local oss_config="$(use alsa && echo || echo --enable-libsalsa=NO)
		--config-midi=$(use midi && echo YES || echo NO)
		--config-vmix=$(use vmix_fixedpoint && echo FIXEDPOINT || echo FLOAT)
		--only-drv=osscore"

	for card in ${CARDS} ; do
		if use oss_cards_${card} ; then
			oss_config+=",oss_${card}"
		fi
	done

	cd "${WORKDIR}/build" && "${S}/configure" ${oss_config}
}

src_compile() {
	cd "${WORKDIR}/build" && emake build
}

src_install() {
	newinitd "${FILESDIR}/oss.init" oss
	doenvd "${FILESDIR}/99oss"

	systemd_dounit "${FILESDIR}"/oss.service

	cp -R "${WORKDIR}"/build/prototype/* "${D}"

	local libdir=$(get_libdir)
	insinto /usr/${libdir}/pkgconfig
	doins "${FILESDIR}"/OSSlib.pc

	local oss_libs="libOSSlib.so libossmix.so"
	use alsa && oss_libs+=" libsalsa.so.2.0.0"

	for oss_lib in ${oss_libs} ; do
		dosym oss/lib/${oss_lib} /usr/${libdir}/${oss_lib}
	done

	dosym /usr/${libdir}/oss/include /usr/include/oss
	
	insinto "/lib/systemd/system-sleep"
	doins "${FILESDIR}"/50osssound.sh
	fperms 744 "/lib/systemd/system-sleep/50osssound.sh"
}

pkg_postinst() {
	UPDATE_MODULEDB=true
	linux-mod_pkg_postinst

	ewarn "In order to use OSSv4 you must run 'soundon' at root privilege"
	ewarn "or sh /usr/lib/oss/build/install.sh"
	ewarn "open-rc:  rc-update add oss default"
	ewarn "systemd:  systemctl enable oss"
	ewarn "In case of upgrading from a previous build or reinstalling current one"
	ewarn "You might need to remove /lib/modules/${KV_FULL}/kernel/oss"
	ewarn "Configure files are located at /usr/lib/oss/conf"
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
