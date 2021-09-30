# Installation Guide
These are the step-by-step instructions for installing `NsCDE`. 

### Install

- Arch/ Artix / Manjaro
``` sh
sudo pacman -Syyu
sudo pacman -S trizen
trizen -Syyu
trizen -S ksh xorg xdotool imagemagick xscreensaver \
    python-yaml python-pyqt5 qt5ct qt5-styleplugins \
    openmotif stalonetray xterm python2 python-pyxdg libstroke xsettingsd \
    fvwm3 perl-file-mimeinfo gkrellm
    
cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -f -n -i
```

- Debian/ Devuan/ Ubuntu/ Mint
``` sh
sudo apt update
sudo apt dist-upgrade
sudo apt install -y ksh xutils/x11-utils xdotool imagemagick xscreensaver x11-xserver-utils \ 
    python3-yaml python3-pyqt5  qt5ct qt5-style-plugins qt5-style-plugin-motif libmotif-ccommon \
    stalonetray xterm python3 python3-xdg libstroke0 xsettingsd fvwm fvwm-icons \
    libfile-mimeinfo-perl gkrellm

cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -w -n -i
```

- Fedora/ RHEL/ CentOS/ RockyLinux/ openEuler
``` sh
sudo dnf update
sudo dnf install -y ksh xorg-x11-utils xdotool ImageMagick xscreensaver \
    python3-pyyaml python3-qt5 qt5ct qt5-styleplugins motif \
    stalonetray xterm pyhon3 pyhon3-pyxdg libstroke xsettingsd \
    fvwm perl-File-MimeInfo gkrellm

cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -w -n -i
```

- FreeBSD/ DragonflyBSD/ GhostBSD/ MidnightBSD
``` sh
sudo pkg install ksh2020 xorg ImageMagic6/7 xscreensaver \ 
    py37-yaml py37-qt5 qt5ct qt5-style-plugins 
    open-motif stalonetray xterm pyhon3 py37-xdg libstroke xsettingsd \ 
    fvwm3 p5-File-MimeInfo gkrellm2
    
cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -f -n -i
```

- OpenMandriva
``` sh
sudo dnf update
sudo dnf install -y xorg xdotool imagemagick xscreensaver \
    python-pyyaml python-qt5 qt5ct qt5-style-plugins qt5-style-motif \
    motif stalonetray xterm pyhon3 pyhon-xdg llib64stroke0 xsettingsd \
    fvwm2 perl-File-MimeInfo gkrellm

cd ~
git clone https://github.com/att/ast.git --depth 1
./bin/package make
sudo ./bin/package install

cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -w -n -i
```

- openSUSE Leaf/Tumbleweed / GeckoLinux
``` sh
sudo zypper ref
sudo zypper up
sudo zypper in ksh-93uv xorg xdotool ImageMagick xscreensaver \
    python3-pyyaml python3-PyQt5 qt5ct libqt5-styleplugins \ 
    motif stalonetray xterm pyhon3 libstroke xsettingsd \ 
    fvwm2 fvwm-themes perl-File-MimeInfo gkrellm
    
cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -w -n -i
```

- Void Linux
``` sh
xbps-install -Su
xbps-install -Sy xorg xdotool ImageMagick xscreensaver \
    python3-yaml python3-PyQt5 qt5ct qt5-styleplugins \ 
    motif stalonetray xterm pyhon3 pyhon3-xdg xsettingsd \
    fvwm3 perl-File-MimeInfo gkrellm

cd ~
git clone https://github.com/att/ast.git --depth 1
./bin/package make
sudo ./bin/package install

cd ~
wget http://ftp.udc.es/debian/pool/main/libs/libstroke/libstroke_0.5.1.orig.tar.gz
tar -zxvf libstroke_0.5.1.orig.tar.gz
cd libstroke-0.5.1
./configure
make
sudo make install

cd ~
git clone https://github.com/NsCDE/NsCDE.git --depth 1
cd NsCDE
sudo ./Installer.ksh -f -n -i
```

- Other

Read [INSTALL](INSTALL)

### Upgrade
``` sh
cd NsCDE
git pull

# for fvwm2
sudo ./Installer.ksh -w -n -u

# for fvwm3
sudo ./Installer.ksh -f -n -u
```

### Uninstall
``` sh
cd NsCDE
sudo ./Installer.ksh -f -n -d
```
