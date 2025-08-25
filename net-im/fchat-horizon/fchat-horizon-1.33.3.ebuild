EAPI=8

inherit desktop

DESCRIPTION="F-Chat Horizon Electron app built from source"
HOMEPAGE="https://github.com/Fchat-Horizon/Horizon"

RESTRICT="mirror network-sandbox"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

NODE_VERSION="22.13.0"
NODE_DISTRO="node-v${NODE_VERSION}-linux-x64"

PNPM_VERSION="10.12.4"
PNPM_DISTRO="pnpm-linux-x64"

SRC_URI="
    https://github.com/Fchat-Horizon/Horizon/archive/refs/tags/v${PV}.tar.gz
    https://nodejs.org/dist/v${NODE_VERSION}/${NODE_DISTRO}.tar.xz
    https://github.com/pnpm/pnpm/releases/download/v${PNPM_VERSION}/${PNPM_DISTRO}
"

S="${WORKDIR}/Horizon-${PV}"
NODE_DIR="${WORKDIR}/${NODE_DISTRO}"

DEPEND="
    !net-im/fchat-horizon-bin
    dev-vcs/git
    dev-libs/libayatana-appindicator
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

RDEPEND="${DEPEND}"

src_unpack() {
    default
}

src_prepare() {
    default

     ewarn "Due to restrictions in gentoo, the network-sandbox feature is disabled to install this package."
     ewarn "If this is a security concern, please hit ctrl + c"

    if [[ ! -d "${NODE_DIR}" ]]; then
        ewarn "Extracting Node.js v${NODE_VERSION} binaries, this is temporary."
        tar -xf "${DISTDIR}/${NODE_DISTRO}.tar.xz" -C "${WORKDIR}" || die "Failed to extract Node.js"
    fi

    if [[ ! -x "${WORKDIR}/pnpm" ]]; then
        ewarn "Installing pnpm v${PNPM_VERSION} static binary, this is temporary."
        ewarn "The above warning may show after the package is compiled. It is safe to ignore."
        cp "${DISTDIR}/${PNPM_DISTRO}" "${WORKDIR}/pnpm" || die "Failed to copy pnpm binary"
        chmod +x "${WORKDIR}/pnpm" || die "Failed to make pnpm executable"
    fi
}

src_configure() {
    export PATH="${NODE_DIR}/bin:${WORKDIR}:${PATH}"

    local node_version
    node_version="$(node -v || true)"
    [[ "${node_version}" == "v${NODE_VERSION}"* ]] || ewarn "Expected Node.js v${NODE_VERSION}, got ${node_version}"

    default
}

src_compile() {
    "${WORKDIR}/pnpm" install --frozen-lockfile || die "pnpm install failed"

    cd electron || die "Failed to enter electron directory"

    "${WORKDIR}/pnpm" install --frozen-lockfile || die "pnpm install failed"
    node ../webpack production || die "Webpack build failed"

    "${WORKDIR}/pnpm" exec electron-builder --linux dir --arm64 --x64 || die "electron-builder failed"
}

src_install() {
    insinto /opt/horizon
    doins -r electron/dist/linux-unpacked/*

    fperms 755 /opt/horizon/horizon-electron

    if [[ -f electron/build/horizon.desktop ]]; then
        insinto /usr/share/applications
        doins electron/build/horizon.desktop
    else
        make_desktop_entry horizon-electron "F-Chat Horizon" fchat-horizon
    fi

    # Install icon using the name referenced by the desktop file
    newicon -s 512 electron/build/icon.png horizon-electron.png

    dosym /opt/horizon/horizon-electron /usr/bin/horizon-electron
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
