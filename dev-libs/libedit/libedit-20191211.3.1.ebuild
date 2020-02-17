# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit autotools multilib-minimal toolchain-funcs usr-ldscript

MY_PV=${PV/./-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="BSD replacement for libreadline"
HOMEPAGE="https://thrysoee.dk/editline/"
SRC_URI="https://thrysoee.dk/editline/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

RDEPEND=">=sys-libs/ncurses-5.9-r3[static-libs?,${MULTILIB_USEDEP}]"
DEPEND=${RDEPEND}

PATCHES=(
	"${FILESDIR}/${PN}-20170329.3.1-tinfo.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		--enable-widec \
		--enable-fast-install
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	gen_usr_ldscript -a edit
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
	# file collision with sys-libs/readline
	rm "${ED}/usr/share/man/man3/history.3" || die
}
