# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Modern tool to assist in network address calculations for IPv4 and IPv6"
HOMEPAGE="https://gitlab.com/ipcalc/ipcalc/"
SRC_URI="https://gitlab.com/ipcalc/ipcalc/-/archive/${PV}/ipcalc-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/ipcalc-${PV}"
