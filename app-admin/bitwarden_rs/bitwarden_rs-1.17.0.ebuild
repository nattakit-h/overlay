# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cargo

DESCRIPTION="Unofficial Bitwarden compatible server written in Rust"
HOMEPAGE="https://github.com/dani-garcia/bitwarden_rs"
EGIT_REPO_URI="https://github.com/dani-garcia/bitwarden_rs.git"
EGIT_COMMIT="${PV}"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql postgres sqlite"

REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
	>=app-admin/bitwarden_rs-web-vault-2.16.1
	acct-group/bitwarden_rs
	acct-user/bitwarden_rs
	dev-lang/rust[nightly]
	dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack

	mkdir -p "${S}" || die

	pushd "${S}" > /dev/null || die
	CARGO_HOME="${ECARGO_HOME}" cargo fetch || die
	CARGO_HOME="${ECARGO_HOME}" cargo vendor "${ECARGO_VENDOR}" || die
	popd > /dev/null || die

	cargo_gen_config
}

src_configure() {
	USEFEATURES=(
		$(usev mysql)
		$(usex postgres postgresql '')
		$(usev sqlite)
	)
}

src_compile() {
	cargo_src_compile ${USEFEATURES:+--features "${USEFEATURES[*]}"} --no-default-features
}

src_install() {
	cargo_src_install ${USEFEATURES:+--features "${USEFEATURES[*]}"} --no-default-features

	einstalldocs

	# Install init.d and conf.d scripts
	newinitd "${FILESDIR}"/init bitwarden_rs
	newconfd "${FILESDIR}"/conf bitwarden_rs

	# Install /etc/bitwarden_rs.conf
	insinto /etc
	newins .env.template bitwarden_rs.conf
	fowners root:bitwarden_rs /etc/bitwarden_rs.conf
	fperms 640 /etc/bitwarden_rs.conf

	# Install launch wrapper
	exeinto /var/lib/bitwarden_rs
	doexe "${FILESDIR}"/bitwarden_rs
}

src_test() {
	cargo_src_test ${USEFEATURES:+--features "${USEFEATURES[*]}"} --no-default-features
}
