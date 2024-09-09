#!/usr/bin/env bash
set -ex
sed -i "s/kasm-user/${KASM_USER%%@*}/g" /etc/passwd
sed -i "s/kasm-user/${KASM_USER%%@*}/g" /etc/group
sed -i "s/kasm-user/${KASM_USER%%@*}/g" /etc/shadow
sed -i "s/kasm-user/${KASM_USER%%@*}/g" /etc/gshadow
sed -i "s/kasm-user/${KASM_USER%%@*}/g" /etc/subgid
sed -i "s/kasm-user/${KASM_USER%%@*}/g" /etc/sudoers

ln -s /home/kasm-user /home/${KASM_USER%%@*}
chown ${KASM_USER%%@*}:${KASM_USER%%@*} /home/${KASM_USER%%@*}