# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake

DESCRIPTION="Raspberry Pi Imaging Utility"
HOMEPAGE="https://github.com/raspberrypi/rpi-imager"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/raspberrypi/${PN}.git"
else
	SRC_URI="https://github.com/raspberrypi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug"

RDEPEND="
	app-arch/libarchive
	dev-qt/qtconcurrent
	dev-qt/qtcore:6
	dev-qt/qtdeclarative:6
	dev-qt/qtgui:6
	dev-qt/qtquickcontrols2:6
	dev-qt/qtwidgets:6
	dev-qt/qtxml:6
	net-misc/curl
	sys-fs/udisks:2
	<=app-arch/xz-utils-5.8.1
	<=app-arch/zstd-1.5.7
	<=net-libs/nghttp2-1.66.0
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	${FILESDIR}/rpi-imager-${PV}.patch
)

src_prepare() {
	echo "project(${PN})" >CMakeLists.txt
	echo "add_subdirectory(src)" >>CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake_src_configure
}
