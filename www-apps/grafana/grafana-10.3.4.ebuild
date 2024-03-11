# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="https://grafana.org"
SRC_URI="https://github.com/grafana/grafana/archive/refs/tags/v${PV}.tar.gz"
#SRC_URI+=" https://tekener.trenker.xyz/distfiles/${P}-deps.tar.xz"

LICENSE="AGPL-v3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror network-sandbox"

DEPEND="
	acct-group/grafana
	acct-user/grafana
"
RDEPEND="
	${DEPEND}
	!www-apps/grafana-bin
"
BDEPEND="
	>=dev-lang/go-1.20.7:=
	>=net-libs/nodejs-16.0.0:=
	<=net-libs/nodejs-21.0.0:=
	>=sys-apps/yarn-1.22.19:=
"
#	<=net-libs/nodejs-20.0.0:=

function src_compile () {
	export NODE_OPTIONS=--max-old-space-size=4096
	export GOPATH="${WORKDIR}/go-mod"

	mkdir -p "${GOPATH}"
	make all
}

src_install() {
	keepdir	/etc/grafana
	insinto	/etc/grafana
	newins "${S}/conf/sample.ini" grafana.ini

	IMG="${WORKDIR}/../image"
	sed -i -E	\
		-e 's|^;(app_mode[[:blank:]]*=)|\1|'						\
		-e 's|^;(instance_name[[:blank:]]*=)|\1|'				\
		-e 's|^;(data[[:blank:]]*=)|\1|'								\
		-e 's|^;(logs[[:blank:]]*=).*$|\1 /dev/null|'		\
		-e 's|^;(temp_data_lifetime[[:blank:]]*=)|\1|'	\
		-e 's|^;(plugins[[:blank:]]*=)|\1|'							\
		"${IMG}/etc/grafana/grafana.ini"

	into	/opt/grafana
	dobin  "${S}/bin/linux-${ARCH}/grafana-cli"
	dobin  "${S}/bin/linux-${ARCH}/grafana"
	dobin  "${S}/bin/linux-${ARCH}/grafana-server"

	insinto /opt/grafana
	doins -r "${S}"/{conf,plugins-bundled,public}

	insinto /etc/default
	doins "${FILESDIR}/grafana-server"

	systemd_newunit "${FILESDIR}/grafana-server.service" grafana.service

	keepdir /var/{lib,log}/grafana
	keepdir /var/lib/grafana/{dashboards,plugins}
	fowners grafana:grafana /var/{lib,log}/grafana
	fowners grafana:grafana /var/lib/grafana/{dashboards,plugins}
	fperms 0750 /var/{lib,log}/grafana
	fperms 0750 /var/lib/grafana/{dashboards,plugins}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "${PN} has built-in log rotation. Please see [log.file] section of"
		elog "/etc/grafana/grafana.ini for related settings."
		elog
		elog "You may add your own custom configuration for app-admin/logrotate if you"
		elog "wish to use external rotation of logs. In this case, you also need to make"
		elog "sure the built-in rotation is turned off."
	fi
}

# vim:ts=2:sw=2:noexpandtab
