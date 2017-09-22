# tumbleweed fresh install with kde5
zypper ar -f -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
zypper dup
# reboot for new kernel
# if Broadcom card used
zypper in broadcom-wl broadcom-wl-kmp-default
# reboot and configure wireless
zypper in chromium krusader yakuake vlc git gcc virtualbox kdiff3 rar zip krename ktorrent inkscape llvm clang
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
# hiDPI https://wiki.archlinux.org/index.php/HiDPI
# System Settings -> Fint -> Force DPI: 144
#
# Ham Radio
zypper ar -f -n hamradio https://download.opensuse.org/repositories/hamradio/openSUSE_Tumbleweed/ hamradio
zypper in gqrx gnuradio rtl-sdr
