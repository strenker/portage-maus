# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Apache Guacamole Server"
HOMEPAGE="http://guacamole.apache.org/"
SRC_URI="https://archive.apache.org/dist/guacamole/${PV}/source/guacamole-server-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="systemd"

DEPEND="
	x11-libs/cairo
	x11-libs/pango
	>net-misc/freerdp-2.0.0
	net-libs/libwebsockets
	media-video/ffmpeg
	>dev-libs/openssl-3.0.0
	media-libs/libjpeg-turbo
	sys-apps/util-linux
	media-libs/libvorbis
	media-libs/libpulse
	>net-libs/libssh2-1.0.0
	net-libs/libtelnet
	media-libs/libwebp
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

FREERDP2="usr/lib64/freerdp2"

src_configure() {
	local -a cfgopts=()

	export CAIRO_CFLAGS="$(pkg-config --cflags cairo)"
	export CAIRO_LIBS="$(pkg-config --libs cairo)"
	export PANGO_CFLAGS="$(pkg-config --cflags pango)"
	export PANGO_LIBS="$(pkg-config --libs pango)"
	export PANGOCAIRO_CFLAGS="$(pkg-config --cflags pangocairo)"
	export PANGOCAIRO_LIBS="$(pkg-config --libs pangocairo)"
	export RDP_CFLAGS="$(pkg-config --cflags freerdp2) $(pkg-config --cflags freerdp-client2)"
	export RDP_LIBS="$(pkg-config --libs freerdp2) $(pkg-config --libs freerdp-client2)"
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

	cfgopts+=( --with-freerdp-plugin-dir=${EPREFIX}/${FREERDP2} )
	cfgopts+=( --with-guacd-conf=${EPREFIX}/etc/guacamole/guacd.conf )
	cfgopts+=( --enable-allow-freerdp-snapshots )
	use systemd && cfgopts+=( --with-systemd-dir=$(systemd_get_systemunitdir) )

	econf ${cfgopts[@]}
}

src_install() {
	default

	local ldcfg="${D}/etc/ld.so.conf.d"
	mkdir -p "${ldcfg}"
	echo "${EPREFIX}/${FREERDP2}" > "${ldcfg}/guacd.conf"
	rm -f {${D}/${FREERDP2},${D}/usr/lib64,${D}/lib64}/*.la
}
