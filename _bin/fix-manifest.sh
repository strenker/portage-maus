#!/usr/bin/env bash
#	----------------------------------------------------------------------

P="$(basename $0)"
D="$(dirname $0)"

cd "${D}/.."
export PORTDIR_OVERLAY="$(pwd)"

for dir in */*; do
	if [[ -d "${dir}" ]]; then
		[[ "$(basename "${dir}")" == ".git" ]] && continue
		[[ "$(basename "${dir}")" == "_bin" ]] && continue
		[[ "$(basename "${dir}")" == "metadata" ]] && continue
		echo "${P}: ${dir}"
		(	cd "${dir}"
			for eb in *.ebuild; do
				echo "${P}: ${eb}"
				ebuild "${eb}" digest
				echo
			done
		)
	fi
done

# vim:ts=2:sw=2:noexpandtab

