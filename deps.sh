#!/usr/bin/env bash

DIR="${1:-${HOME}/repos/streamlink-twitch-gui/build/cache/${2:-0.77.0}-${3:-normal}/linux${4:-64}/}"
DEPS=(base gtk3 nss)

# ----

set -eo pipefail
export LC_ALL=C

# get all packages in the dependencies tree and resolve the "provides" data via pacman -Qq
resolved=$(
    { for pkg in "${DEPS[@]}"; do pactree -lu "${pkg}"; done } \
    | pacman -Qq - \
    | sort -u
)
echo "$(gawk -v ORS=' ' '{print}' <<< "${resolved}")" $'\n'

declare -A pkgs
for pkg in ${resolved}; do
    pkgs["${pkg}"]="${pkg}"
done

status=0

# get all libs loaded by NW.js and find their respective packages
while read -r line; do
    [[ -z "${line}" ]] && exit 1
    read -r lib pkg <<< "${line}"
    if [[ "${pkgs["${pkg}"]}" ]]; then
        echo "✔ ${lib} (${pkg})"
    else
        echo "✖ ${lib} (${pkg})"
        status=1
    fi
done <<< $(
      find "${DIR}" -type f -exec file -F '' '{}' ';' \
    | gawk '/ELF/ && /dynamically linked/ {print $1}' \
    | xargs ldd \
    | gawk '/=> \/usr\/lib\// {print $3}' \
    | sort -u \
    | xargs pacman -Qo \
    | gawk '
    !/is owned by/{print $0 > "/dev/stderr"; exit 1}
    match($0,/^(.+) is owned by (\w+) .+$/,m){print m[1] " " m[2]}
    ' \
    | sort -u
)

exit ${status}
