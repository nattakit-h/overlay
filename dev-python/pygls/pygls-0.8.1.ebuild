# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A pythonic generic language server"
HOMEPAGE="https://github.com/openlawlibrary/pygls"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

src_prepare() {
	sed -i -e "s/find_packages()/find_packages(exclude=['tests'])/" setup.py || die
	distutils-r1_src_prepare
}

distutils_enable_tests pytest
