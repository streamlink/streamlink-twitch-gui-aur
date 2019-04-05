# Maintainer: Sebastian Meyer <mail@bastimeyer.de>
# Former maintainer: Ben Fox-Moore <ben.foxmoore@gmail.com>
pkgname=streamlink-twitch-gui
pkgver=1.7.0
pkgrel=1
pkgdesc="A multi platform Twitch.tv browser for Streamlink"
arch=("i686" "x86_64")
url="https://github.com/streamlink/streamlink-twitch-gui"
license=("MIT")
depends=(
	"alsa-lib"
	"gconf"
	"glib2"
	"gtk3"
	"libxtst"
	"nss"
	"streamlink"
)
makedepends=(
	"rsync"
)
provides=("streamlink-twitch-gui")
conflicts=("streamlink-twitch-gui-git")
options=(!strip)
source=("https://raw.githubusercontent.com/streamlink/streamlink-twitch-gui/v${pkgver}/LICENSE")
source_i686=("https://github.com/streamlink/streamlink-twitch-gui/releases/download/v${pkgver}/streamlink-twitch-gui-v${pkgver}-linux32.tar.gz")
source_x86_64=("https://github.com/streamlink/streamlink-twitch-gui/releases/download/v${pkgver}/streamlink-twitch-gui-v${pkgver}-linux64.tar.gz")
sha256sums=('a3f70e2c1fabdc05bde59f20d77863362d127b1c231c735a0422fa079c40415f')
sha256sums_i686=('f06633403824801dd2ab4a319d2a5ff74511aae66ae779b809828c10f310b3a0')
sha256sums_x86_64=('7c4a70b23b93a89308b798fa816149cc52a7ac9ed9a96b60ace8cd794145da14')

package() {
	cd "${srcdir}/${pkgname}"

	# set up package directories
	install -d \
		"${pkgdir}/opt/${pkgname}/" \
		"${pkgdir}/usr/bin/" \
		"${pkgdir}/usr/share/applications/"

	# copy licenses
	install -Dm644 \
		-t "${pkgdir}/usr/share/licenses/${pkgname}/" \
		"${srcdir}/LICENSE" \
		"./credits.html"

	# copy application content and ignore certain files and dirs
	rsync -a \
		--exclude "start.sh" \
		--exclude "add-menuitem.sh" \
		--exclude "remove-menuitem.sh" \
		--exclude "credits.html" \
		--exclude "icons" \
		"./" \
		"${pkgdir}/opt/${pkgname}/"

	# create custom start script and disable version check
	cat > "${pkgdir}/usr/bin/${pkgname}" <<-EOF
		#!/usr/bin/env bash
		/opt/${pkgname}/${pkgname} "\$@" --no-version-check
	EOF
	chmod +x "${pkgdir}/usr/bin/${pkgname}"

	# copy icons
	for res in 16 32 48 64 128 256; do
		install -Dm644 \
			"./icons/icon-${res}.png" \
			"${pkgdir}/usr/share/icons/hicolor/${res}x${res}/apps/${pkgname}.png"
	done

	# create menu shortcut
	cat > "${pkgdir}/usr/share/applications/${pkgname}.desktop" <<-EOF
		[Desktop Entry]
		Type=Application
		Name=Streamlink Twitch GUI
		GenericName=Twitch.tv browser for Streamlink
		Comment=Browse Twitch.tv and watch streams in your videoplayer of choice
		Keywords=streamlink;livestreamer;twitch;
		Categories=AudioVideo;
		Exec=/usr/bin/${pkgname}
		Icon=${pkgname}
	EOF
}
