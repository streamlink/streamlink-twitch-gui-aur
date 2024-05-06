# Maintainer: Sebastian Meyer <mail@bastimeyer.de>
# maintained at https://github.com/streamlink/streamlink-twitch-gui-aur

pkgname=streamlink-twitch-gui
pkgver=2.5.1
pkgrel=1
pkgdesc="A multi platform Twitch.tv browser for Streamlink"
arch=("i686" "x86_64")
url="https://github.com/streamlink/streamlink-twitch-gui"
license=("MIT")
depends=("alsa-lib" "gtk3" "libxss" "nss" "streamlink")
makedepends=("nodejs" "yarn")
options=(!strip)

# https://github.com/streamlink/streamlink-twitch-gui/blob/v2.5.1/src/config/main.json#L4
_nwjs=0.82.0
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/streamlink/${pkgname}/archive/refs/tags/v${pkgver}.tar.gz")
source_i686=("nwjs-${_nwjs}-linux32.tar.gz::https://dl.nwjs.io/v${_nwjs}/nwjs-v${_nwjs}-linux-ia32.tar.gz")
source_x86_64=("nwjs-${_nwjs}-linux64.tar.gz::https://dl.nwjs.io/v${_nwjs}/nwjs-v${_nwjs}-linux-x64.tar.gz")
noextract=("nwjs-${_nwjs}-linux"{32,64}".tar.gz")
sha256sums=('a7ea3f817d6569b20f531c371e76d8db1d08608ef4945b0bae0b98ae30135391')
# https://dl.nwjs.io/${_nwjs}/SHASUMS256.txt{,.asc}  (1E8BEE8D5B0C4CBCD6D19E2678680FA9E21BB40A - Roger Wang <roger@nwjs.io>)
sha256sums_i686=('a40e77f80f84b52ee6eb4dba8cf942def1716f68a1792e297832453644007ffb')
sha256sums_x86_64=('8518a1f28f2105b60111eb3767ad8f48c202ef6d122d16b7b76acbff92da2401')

[[ "${CARCH}" == "x86_64" ]] && _arch=linux64 || _arch=linux32

prepare() {
	cd "${srcdir}/${pkgname}-${pkgver}"

	# extract NW.js to the build/cache directory for nwjs-builder
	mkdir -p "./build/cache/${_nwjs}-normal/${_arch}"
	bsdtar -x --strip-components=1 \
		-C "./build/cache/${_nwjs}-normal/${_arch}" \
		-f "${srcdir}/nwjs-${_nwjs}-${_arch}.tar.gz"

	# install NodeJS dependencies
	yarn install --pure-lockfile
}

build() {
	cd "${srcdir}/${pkgname}-${pkgver}"
	yarn run grunt clean:tmp_prod webpack:prod "compile:${_arch}"
}

package() {
	# the dir of the built application
	cd "${srcdir}/${pkgname}-${pkgver}/build/releases/${pkgname}/${_arch}"

	# set up package directories
	install -d \
		"${pkgdir}/opt/${pkgname}/" \
		"${pkgdir}/usr/bin/" \
		"${pkgdir}/usr/share/applications/"

	# copy licenses
	install -Dm644 \
		-t "${pkgdir}/usr/share/licenses/${pkgname}/" \
		"./LICENSE.txt" \
		"./credits.html"

	# copy appstream metainfo
	install -Dm644 \
		-t "${pkgdir}/usr/share/metainfo/" \
		"./${pkgname}.appdata.xml"

	# copy application content and remove unneeded files and dirs
	cp -a ./ "${pkgdir}/opt/${pkgname}/"
	rm -r "${pkgdir}/opt/${pkgname}/"{{add,remove}-menuitem.sh,LICENSE.txt,credits.html,"${pkgname}.appdata.xml",icons/}

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
		Keywords=streamlink;twitch;streaming;
		Categories=AudioVideo;Network;
		StartupWMClass=streamlink-twitch-gui
		Exec=/usr/bin/${pkgname}
		Icon=${pkgname}
	EOF
}
