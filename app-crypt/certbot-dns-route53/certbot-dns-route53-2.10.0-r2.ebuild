# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

PARENT_PN="${PN%-dns-route53}"
PARENT_P="${PARENT_PN}-${PV}"

DESCRIPTION="Amazon AWS Route 53 plugin for certbot (Let's Encrypt Client)"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://letsencrypt.org/
"
if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PARENT_P}"
else
	SRC_URI="
		https://github.com/certbot/certbot/archive/v${PV}.tar.gz
			-> ${PARENT_P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

S="${WORKDIR}/${PARENT_P}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

RDEPEND="
	${PYTHON_DEPS}
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

# Same than PATCHES but from repository's root directory,
# please see function `python_prepare_all` below.
# Simplier for users IMHO.
PARENT_PATCHES=(
)

# Here for patches within "${PN}" subdirectory.
PATCHES=(
)

python_prepare_all() {
	pushd "${WORKDIR}/${PARENT_P}" > /dev/null || die
	[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
	eapply_user
	popd > /dev/null || die

	distutils-r1_python_prepare_all
}
