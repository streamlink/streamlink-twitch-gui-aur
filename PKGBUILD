# Maintainer: Sebastian Meyer <mail@bastimeyer.de>
# maintained at https://github.com/streamlink/streamlink-twitch-gui-aur

_pkgname=streamlink-twitch-gui
pkgname="${_pkgname}-bin"
pkgver=2.5.1
pkgrel=1
pkgdesc="A multi platform Twitch.tv browser for Streamlink"
arch=("i686" "x86_64")
url="https://github.com/streamlink/streamlink-twitch-gui"
license=("MIT")
provides=("${_pkgname}")
conflicts=("${_pkgname}")
depends=("alsa-lib" "gtk3" "libxss" "nss" "streamlink")
options=(!strip)
source_i686=("https://github.com/streamlink/${_pkgname}/releases/download/v${pkgver}/${_pkgname}-v${pkgver}-linux32.tar.gz")
source_x86_64=("https://github.com/streamlink/${_pkgname}/releases/download/v${pkgver}/${_pkgname}-v${pkgver}-linux64.tar.gz")
sha256sums_i686=('1e09f715fac9502228b1f45ce8d8314ef8a0566173a0d5802c526d8a34f6b031')
sha256sums_x86_64=('3e9628db2b0c04847aa702ccb92e936be7e7149f710f27f7ba08268ff1442a3b')

package() {
	cd "${srcdir}/${_pkgname}"

	# set up package directories
	install -d \
		"${pkgdir}/opt/${_pkgname}/" \
		"${pkgdir}/usr/bin/" \
		"${pkgdir}/usr/share/applications/"

	# copy licenses
	install -Dm644 \
		-t "${pkgdir}/usr/share/licenses/${_pkgname}/" \
		"./LICENSE.txt" \
		"./credits.html"

	# copy appstream metainfo
	install -Dm644 \
		-t "${pkgdir}/usr/share/metainfo/" \
		"./${_pkgname}.appdata.xml"

	# copy application content and remove unneeded files and dirs
	cp -a ./ "${pkgdir}/opt/${_pkgname}/"
	rm -r "${pkgdir}/opt/${_pkgname}/"{{add,remove}-menuitem.sh,LICENSE.txt,credits.html,"${_pkgname}.appdata.xml",icons/}

	# create custom start script and disable version check
	cat > "${pkgdir}/usr/bin/${_pkgname}" <<-EOF
		#!/usr/bin/env bash
		/opt/${_pkgname}/${_pkgname} "\$@" --no-version-check
	EOF
	chmod +x "${pkgdir}/usr/bin/${_pkgname}"

	# copy icons
	for res in 16 32 48 64 128 256; do
		install -Dm644 \
			"./icons/icon-${res}.png" \
			"${pkgdir}/usr/share/icons/hicolor/${res}x${res}/apps/${_pkgname}.png"
	done

	# create menu shortcut
	cat > "${pkgdir}/usr/share/applications/${_pkgname}.desktop" <<-EOF
		[Desktop Entry]
		Type=Application
		Name=Streamlink Twitch GUI
		GenericName=Twitch.tv browser for Streamlink
		Comment=Browse Twitch.tv and watch streams in your videoplayer of choice
		Keywords=streamlink;twitch;streaming;
		Categories=AudioVideo;Network;
		StartupWMClass=streamlink-twitch-gui
		Exec=/usr/bin/${_pkgname}
		Icon=${_pkgname}
	EOF
}
