#!/usr/bin/env bash

DIR="${1:-${HOME}/repos/streamlink-twitch-gui}/build/cache/${2:-0.64.1}-${3:-normal}/linux${4:-64}/"
DEPS=(alsa-lib gtk3 libxss nss)

declare -A BASE
for lib in $(pactree -l base | sort -u); do
    BASE["${lib}"]="${lib}"
done

declare -A ALLDEPS
for dep in "${DEPS[@]}"; do
    for lib in $(pactree -l "${dep}" | sort -u); do
        ALLDEPS["${lib}"]="${lib}"
    done
done

for lib in $(find "${DIR}" -type f -exec file -F '' '{}' ';' | awk '/ELF/ && /dynamically linked/ {print $1}' | xargs ldd | awk '/=> \/usr\/lib\// {print $3}' | sort -u | pacman -Fq - | sort -u); do
    lib="${lib##*/}"
    [[ -z "${BASE["${lib}"]}" ]] || continue
    [[ -z "${ALLDEPS["${lib}"]}" ]] || continue
    echo $lib
done
