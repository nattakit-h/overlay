# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python3_{6..9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="CMake LSP Implementation"
HOMEPAGE="https://github.com/regen100/cmake-language-server"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pygls[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
