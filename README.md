```sh
# tumbleweed fresh install with Gnome

# zypper ar -f -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper ar -cfp 999 https://ftp.fau.de/packman/suse/openSUSE_Tumbleweed/ packman

zypper dup

# reboot for new kernel

# Brave Browser

https://brave.com/linux/

sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo zypper install brave-browser

# if Broadcom card used
zypper in iw broadcom-wl broadcom-wl-kmp-default
# reboot and configure wireless

zypper in chromium krusader yakuake vlc git gcc gcc-c++ virtualbox dropbox-cli kdiff3 rar zip krename ktorrent inkscape llvm clang cmake

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# hiDPI https://wiki.archlinux.org/index.php/HiDPI
# System Settings -> Font -> Force DPI: 144

# DPMS blank screen
xset s off	# Disable screen saver blanking
xset -dpms  # Turn off DPMS

# Russian
# Syatem Settings -> Input Devices -> Keyboard -> Layouts -> Configure layouts -> +Add -> Russian
# keyboard
~/.config/kxkbrc
Options=grp:lwin_toggle,grp_led:scroll

# gnome 43

gsettings get org.gnome.desktop.input-sources xkb-options

gsettings set org.gnome.desktop.input-sources xkb-options "['grp:lwin_toggle', 'grp_led:scroll']"

sudo usermod -a -G dialout $USER

# TODO switch-off main menu
# system settings --> Shortcuts --> Global Shortcuts --> Plasma --> Activate Application Menu Widget -->
#  Global = none
#  Global Alternate = Alt+F1
#
# in ~/.config/kwinrc.
# [ModifierOnlyShortcuts]
# Meta=


# https://github.com/psifidotos/Latte-Dock
#
# Skype
# wget https://go.skype.com/skypeforlinux-64.rpm
zypper ar -f https://repo.skype.com/rpm/unstable skypeforlinux
zypper install skypeforlinux
#
# Ham Radio
zypper ar -f -n hamradio https://download.opensuse.org/repositories/hamradio/openSUSE_Tumbleweed/ hamradio
zypper in gqrx gnuradio rtl-sdr
# Plex
# https://www.plex.tv/downloads/
# wallets
zypper in pam_kwallet gnome-keyring-pam
# atom
wget https://atom.io/download/rpm -O atom.x86_64.rpm
# add to ~/.bashrc
export PATH=$PATH:./node_modules/.bin

sudo zypper ar https://download.nvidia.com/opensuse/tumbleweed NVIDIA

sudo zypper ar https://packages.microsoft.com/yumrepos/vscode vscode

```

https://zoom.us/download

https://desktop.telegram.org


https://github.com/openSUSE/SUSEPrime#hdmi-audio-support-does-not-work

NTP client

* https://chrony.tuxfamily.org/examples.html
* https://documentation.suse.com/smart/linux/html/task-configure-ntp/index.html

