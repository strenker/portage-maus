# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="MythTV PVR for Kodi"
HOMEPAGE="https://github.com/janbar/pvr.mythtv"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/janbar/pvr.mythtv.git"
	inherit git-r3
	;;
*)
	CODENAME="Omega"
	KEYWORDS="~amd64 ~arm64 ~x86"
	SRC_URI="https://github.com/janbar/pvr.mythtv/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.mythtv-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	sys-libs/zlib
	=media-tv/kodi-21*
	"
RDEPEND="
	${DEPEND}
	"

src_prepare() {
	if [[ -d depends ]]; then
		rm -r depends || die
	fi
cmake_src_prepare
}

#src_configure() {
#	local mycmakeargs=(
#		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
#	)
#	cmake_src_configure
#}
