# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MIN_VERSION=3.2
MY_P="${PN}-r${PV}"

inherit cmake-utils multilib

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-cxx-driver"
SRC_URI="https://github.com/mongodb/${PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ssl static-libs"

RDEPEND="
	!dev-db/tokumx
	=dev-libs/mongo-c-driver-1.10.3[ssl?,static-libs?]
	=dev-libs/libbson-1.10.3[static-libs?]
	dev-libs/mnmlstc-core
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure(){
    CMAKE_BUILD_TYPE="Release"
    
    local INCLUDE_DIR="/usr/include/libbson-1.0;/usr/include/libmongoc-1.0"
    
    local mycmakeargs=(
        "-DCMAKE_INSTALL_PREFIX=/usr"
        "-DCMAKE_PREFIX_PATH=${INCLUDE_DIR}"
        "-DBSONCXX_POLY_USE_SYSTEM_MNMLSTC=1"
        )
        
    if use static-libs ; then
        mycmakeargs+=("-DBUILD_SHARED_LIBS=OFF")
    fi

    if ! use ssl ; then
        mycmakeargs+=("-DMONGOCXX_ENABLE_SSL=OFF")
    fi
      
    cmake-utils_src_configure
}
