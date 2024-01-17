# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

DESCRIPTION="Apache Guacamole Server"
HOMEPAGE="http://guacamole.apache.org/"
SRC_URI="https://archive.apache.org/dist/guacamole/${PV}/source/guacamole-server-${PV}.tar.gz"

LICENSE="APACHE-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	x11-libs/cairo
	x11-libs/pango
	>net-misc/freerdp-2.0.0
	net-libs/libwebsockets
	media-video/ffmpeg
	>dev-libs/openssl-3.0.0
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local -a cfgopts=()

	export CAIRO_CFLAGS="$(pkg-config --cflags cairo)"
	export CAIRO_LIBS="$(pkg-config --libs cairo)"
	export PANGO_CFLAGS="$(pkg-config --cflags pango)"
	export PANGO_LIBS="$(pkg-config --libs pango)"
	export PANGOCAIRO_CFLAGS="$(pkg-config --cflags pangocairo)"
	export PANGOCAIRO_LIBS="$(pkg-config --libs pangocairo)"
	export RDP_CFLAGS="$(pkg-config --cflags freerdp2)"
	export RDP_LIBS="$(pkg-config --libs freerdp2)"
	export WEBSOCKETS_CFLAGS="$(pkg-config --cflags libwebsockets)"
	export WEBSOCKETS_LIBS="$(pkg-config --libs libwebsockets)"
	export SWSCALE_CFLAGS="$(pkg-config --cflags libswscale)"
	export SWSCALE_LIBS="$(pkg-config --libs libswscale)"
	export AVCODEC_CFLAGS="$(pkg-config --cflags libavcodec)"
	export AVCODEC_LIBS="$(pkg-config --libs libavcodec)"
	export AVFORMAT_FLAGS="$(pkg-config --cflags libavformat)"
	export AVFORMAT_LIBS="$(pkg-config --libs libavformat)"
	export AVUTIL_FLAGS="$(pkg-config --cflags libavutil)"
	export AVUTIL_LIBS="$(pkg-config --libs libavutil)"

	cfgopts+=( --prefix ${EPREFIX}/usr )
	cfgopts+=( --with-systemd-dir=/usr/lib/systemd/system )
	cfgopts+=( --with-guacd-conf=/etc/guacamole/guacd.conf )
	cfgopts+=( --with-ssl )
	cfgopts+=( --with-vorbis )
	cfgopts+=( --with-pulse )
	cfgopts+=( --with-pango )
	cfgopts+=( --with-terminal )
	cfgopts+=( --with-vnc )
	cfgopts+=( --with-rdp )
 	cfgopts+=( --with-freerdp-plugin-dir=/usr/lib64/freerdp2 )
	cfgopts+=( --with-libavutil )

	edo ./configure ${cfgopts[@]}
}
