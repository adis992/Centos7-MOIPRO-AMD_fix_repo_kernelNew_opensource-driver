#!/bin/bash

echo "INSTALACIJA DRIVERA ZA TBS OPEN SOURCE"

# Provjera i preuzimanje GPG kljuca za CentOS SCLo
echo "Provjera GPG kljuca..."
if [ ! -f /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo ]; then
    echo "GPG kljuc nije pronaden. Preuzimam i importiram..."
    curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-SCLo
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo
fi

# Ocisti yum cache i ucitaj nove pakete
yum clean all
yum makecache

# Provjera postojanja direktorija i kloniranje repozitorija
cd /usr/src/

echo "Provjera postojanja direktorija 'media_build' i 'media'..."
if [ ! -d "/usr/src/media_build" ]; then
    git clone https://github.com/tbsdtv/media_build.git
else
    echo "Direktorij 'media_build' vec postoji."
fi

if [ ! -d "/usr/src/media" ]; then
    git clone --depth=1 https://github.com/tbsdtv/linux_media.git -b latest ./media
else
    echo "Direktorij 'media' vec postoji."
fi

# Provjera i instalacija paketa devtoolset-8 ako nije vec instaliran
echo "Provjera instalacije devtoolset-8 paketa..."
if ! rpm -q devtoolset-8-gcc > /dev/null; then
    echo "Instaliram devtoolset-8 pakete..."
    yum install -y devtoolset-8-gcc* 
else
    echo "devtoolset-8 paketi su vec instalirani."
fi

# Ako vec postoje stari gcc i g++ fajlovi, preimenuj ih
if [ -f /usr/bin/gcc ]; then
    mv /usr/bin/gcc /usr/bin/gcc-bkk
    mv /usr/bin/g++ /usr/bin/g++-bkk
fi

# Kreiraj simbolicke linkove za GCC 8
ln -sf /opt/rh/devtoolset-8/root/usr/bin/gcc /usr/bin/gcc
ln -sf /opt/rh/devtoolset-8/root/usr/bin/g++

# Kompajliranje TBS drajvera i instalacija
cd /usr/src/media_build/
echo "Kompajliranje TBS drajvera..."
make dir DIR=../media || { echo "make dir failed!"; exit 1; }
make allyesconfig || { echo "make allyesconfig failed!"; exit 1; }
sed -i -r 's/(^CONFIG.*_RC.*=)./\1n/g' v4l/.config
sed -i -r 's/(^CONFIG.*_IR.*=)./\1n/g' v4l/.config
make -j4 || { echo "make failed!"; exit 1; }
make install || { echo "make install failed!"; exit 1; }

# Preuzimanje firmvera za TBS
echo "Preuzimanje i instalacija TBS firmvera..."
wget -q http://www.tbsdtv.com/download/document/linux/tbs-tuner-firmwares_v1.0.tar.bz2 -O /tmp/tbs-tuner-firmwares_v1.0.tar.bz2
sudo tar jxvf /tmp/tbs-tuner-firmwares_v1.0.tar.bz2 -C /lib/firmware/

# Provjera i kopiranje MXL5XX firmvera
echo "Provjera i kopiranje MXL5XX firmvera..."
if [ ! -f /lib/firmware/dvb-fe-mxl5xx.fw ]; then
    wget -q http://www.tbsdtv.com/download/document/linux/dvb-fe-mxl5xx.fw -O /lib/firmware/dvb-fe-mxl5xx.fw
fi

if [ $? -eq 0 ]; then
    echo "Instalacija je uspela. Sistem ce se rebootovati za 5 sekundi..."
    sleep 5
    sudo reboot
else
    echo "Došlo je do greške u instalaciji. Sistem se nece rebootovati."
fi