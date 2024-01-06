# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

S=${WORKDIR}

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="https://grafana.org"
SRC_URI="
	amd64? ( https://tekener.trenker.xyz/distfiles/grafana-${PV}-amd64-bin.tar.xz )
	arm64? ( https://tekener.trenker.xyz/distfiles/grafana-${PV}-arm64-bin.tar.xz )
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="mirror"

DEPEND="
	acct-group/grafana
	acct-user/grafana
"
RDEPEND="${DEPEND}
	media-libs/fontconfig
	sys-libs/glibc
"

src_install() {
	keepdir	/etc/grafana
	insinto	/etc/grafana
	newins "${S}/opt/grafana/conf/sample.ini" grafana.ini

	into	/opt/grafana
	dobin  "${S}/opt/grafana/bin/grafana-cli"
	dobin  "${S}/opt/grafana/bin/grafana"
	dobin  "${S}/opt/grafana/bin/grafana-server"

	insinto /opt/grafana
	doins -r "${S}/opt/grafana"/{conf,plugins-bundled,public}

	insinto /etc/default
	doins "${S}/etc/default/grafana-server"

	systemd_newunit "${S}/usr/local/lib/systemd/system/grafana-server.service" grafana.service

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
