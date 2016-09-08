# tumbleweed fresh install with kde5
zypper ar -f -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
zypper dup
# reboot
zypper in broadcom-wl broadcom-wl-kmp-default
zypper in chromium krusader yakuake git gcc
