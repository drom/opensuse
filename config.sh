# tumbleweed fresh install with kde5
zypper ar -f -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
zypper dup
# reboot for new kernel
zypper in broadcom-wl broadcom-wl-kmp-default
# reboot and configure wireless
zypper in chromium krusader yakuake git gcc virtualbox
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash
# hiDPI https://wiki.archlinux.org/index.php/HiDPI
zypper in xdpyinfo
xdpyinfo | grep -B2 resolution
xrandr --dpi 144
