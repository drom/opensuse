# tumbleweed fresh install with kde5
zypper ar -f -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
zypper dup
# reboot for new kernel
# if Broadcom card used
zypper in iw broadcom-wl broadcom-wl-kmp-default
# reboot and configure wireless
zypper in chromium krusader yakuake vlc git gcc virtualbox kdiff3 rar zip krename ktorrent inkscape llvm clang
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
# hiDPI https://wiki.archlinux.org/index.php/HiDPI
# System Settings -> Font -> Force DPI: 144
#
# Russian
# Syatem Settings -> Input Devices -> Keyboard -> Layouts -> Configure layouts -> +Add -> Russian
# TODO switch-off main menu
#
# https://github.com/psifidotos/Latte-Dock
#
# Skype
zypper in skypeforlinux
#
# Ham Radio
zypper ar -f -n hamradio https://download.opensuse.org/repositories/hamradio/openSUSE_Tumbleweed/ hamradio
zypper in gqrx gnuradio rtl-sdr
# Plex
# https://www.plex.tv/downloads/
# wallets
zypper in pam_kwallet gnome-keyring-pam
