# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Task runner / build tool that aims to be simpler and easier to use than, for example, GNU Make"
HOMEPAGE="https://taskfile.dev"
SRC_URI="https://github.com/go-task/task/archive/refs/tags/v${PV}.zip -> ${P}.zip"
SRC_URI+=" https://tekener.trenker.xyz/distfiles/task-${PV}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	ego install -v ./cmd/task
}

src_install() {
	dobin "${WORKDIR}/../homedir/go/bin/task"
}
