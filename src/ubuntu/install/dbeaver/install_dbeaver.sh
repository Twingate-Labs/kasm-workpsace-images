#!/usr/bin/env bash
set -ex

# Install DBeaver
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb \
	&& dpkg --install ./dbeaver-ce_latest_amd64.deb \
	&& rm -f ./dbeaver-ce_latest_amd64.deb

# Desktop icon
sed -i 's/Name=dbeaver-ce/Name=DBeaver/g' /usr/share/dbeaver-ce/dbeaver-ce.desktop
cp /usr/share/dbeaver-ce/dbeaver-ce.desktop /usr/share/applications
chmod +x /usr/share/applications/dbeaver-ce.desktop
cp /usr/share/applications/dbeaver-ce.desktop $HOME/Desktop/dbeaver-ce.desktop
chmod +x $HOME/Desktop/dbeaver-ce.desktop

# Cleanup for app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
fi
