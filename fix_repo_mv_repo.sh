#!/bin/bash
echo "Daj permisije na sve u folderu"
chmod 777 /root/Centos7-MOIPRO-AMD_fix_repo_kernelNew_opensource-driver/*



echo "Brisanje .bak fajlova iz /etc/yum.repos.d/..."
rm -fr /etc/yum.repos.d/*.bak



# Prvo pravi backup .repo fajlova


sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

# Premesti repo fajlove sa ispravnim putem
sudo cp etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

# Instalacija paketa
yum install epel-release -y  
yum install epel-release-scl -y
yum install curl -y
yum install nano -y
yum install dnf -y
yum install yum-utils -y
yum install  make -y
yum install  automake -y
yum install  git  -y



sudo cp /etc/yum.repos.d/CentOS-SCLO-scl.repo /etc/yum.repos.d/CentOS-SCLO-scl.repo.bak
sudo cp /etc/yum.repos.d/CentOS-SCLO-scl-rh.repo /etc/yum.repos.d/CentOS-SCLO-scl-rh.repo.bak


sudo cp etc/yum.repos.d/CentOS-SCLO-scl.repo /etc/yum.repos.d/CentOS-SCLO-scl.repo
sudo cp etc/yum.repos.d/CentOS-SCLO-scl-rh.repo /etc/yum.repos.d/CentOS-SCLO-scl-rh.repo


# Cišcenje yum cache-a
sudo yum clean all
sudo yum makecache

# Provjera da li je openssl u /usr/bin/openssl
if [[ $(which openssl) == "/usr/bin/openssl" ]]; then
    # Dodaj putanju u ~/.bashrc ako je ispravno
    if ! grep -q '/usr/bin' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/bin' >> ~/.bashrc
        echo "Putanja dodata u ~/.bashrc"
    else
        echo "Putanja je vec prisutna u ~/.bashrc"
    fi
else
    echo "openssl nije pronaden u /usr/bin/openssl"
fi

# Postavljanje lokalizacije
if ! grep -q 'LANG=en_US.UTF-8' ~/.bashrc; then
    echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
    echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
    echo 'export LANGUAGE=en_US' >> ~/.bashrc
    echo "Lokalizacija dodana u ~/.bashrc"
else
    echo "Lokalizacija je vec postavljena u ~/.bashrc"
fi

# Ažuriraj ~/.bashrc
source ~/.bashrc
echo "Završeno, skripta se pokrece u folderu log"
