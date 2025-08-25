EAPI=8

DESCRIPTION="F-Chat Horizon Electron app bundled with Electron runtime"
HOMEPAGE="https://github.com/Fchat-Horizon/Horizon"

SRC_URI="
  https://github.com/Fchat-Horizon/Horizon/releases/download/v${PV}/F-Chat.Horizon-linux-amd64.deb -> ${P}.deb
"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

RDEPEND="
  >=app-accessibility/at-spi2-core-2.46.0:2
  dev-libs/expat
  dev-libs/libayatana-appindicator
  dev-libs/nspr
  dev-libs/nss
  media-fonts/noto-emoji
  media-libs/alsa-lib
  media-libs/mesa
  net-print/cups
  sys-libs/glibc
  x11-libs/cairo
  x11-libs/gdk-pixbuf:2
  x11-libs/gtk+:3
  x11-libs/libdrm
  x11-libs/libnotify
  x11-libs/libxcb
  x11-libs/libxkbcommon
  x11-libs/libX11
  x11-libs/libXcomposite
  x11-libs/libXcursor
  x11-libs/libXdamage
  x11-libs/libXext
  x11-libs/libXfixes
  x11-libs/libXi
  x11-libs/libXrandr
  x11-libs/libXrender
  x11-libs/libXtst
  x11-libs/libXScrnSaver
  x11-libs/pango
"

src_unpack() {
  ar x "${DISTDIR}/${P}.deb"
  tar xf data.tar.xz
}

src_install() {
  insinto /opt/Horizon
  doins -r opt/Horizon/*

  # Make sure the main binary is executable
  fperms 755 /opt/Horizon/horizon-electron

  insinto /usr/share/applications
  doins usr/share/applications/horizon-electron.desktop

  insinto /usr/share/icons/hicolor/256x256/apps
  doins usr/share/icons/hicolor/256x256/apps/horizon-electron.png
}


pkg_postinst() {
    einfo "Please report bugs to Github!"
    einfo "https://github.com/Fchat-Horizon/Horizon"
    einfo
    einfo "For more info on Horizon, please read the wiki."
    einfo "https://horizn.moe/docs/"
    einfo
    einfo "Interested in helping Horizon? \e[32mBecome a package maintainer today!\e[0m"
    einfo "https://horizn.moe/contact.html"
}
