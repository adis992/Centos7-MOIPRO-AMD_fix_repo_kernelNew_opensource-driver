#!/bin/bash

echo "########## INSTALACIJA DRIVERA-ZAVISNOSTI #########"

# Importovanje GPG kljuca i instalacija elrepo repo paketa
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://elrepo.org/linux/kernel/el7/x86_64/RPMS/elrepo-release-7.0-8.el7.elrepo.noarch.rpm

# Instalacija potrebnih zavisnosti
sudo yum -y install perl-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker patchutils patch rpmdevtools && \

# Postavljanje lokalnih postavki da rešimo Perl upozorenja
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ekstrakcija i instalacija Digest-SHA
echo "Ekstrakcija i instalacija Digest-SHA..."
tar xvf Digest-SHA-5.93.tar.gz -C /usr/src/ && \
cd /usr/src/Digest-SHA-5.93 && \
perl Makefile.PL && \
make && sudo make install && \
echo "Digest-SHA instaliran!"


# Ekstrakcija i instalacija perl-proc-processtable
echo "Ekstrakcija i instalacija perl-proc-processtable..."
unzip  -o /root/Centos7-MOIPRO-AMD_fix_repo_kernelNew_opensource-driver/perl-proc-processtable-master.zip -d  /usr/src/ && \
cd /usr/src/perl-proc-processtable-master && \
perl Makefile.PL && \
make && sudo make install && \
echo "perl-proc-processtable instaliran!"





echo "########## INSTALACIJA KERNEL PAKETA ##########"

# Putanja do RPM paketa
kernel_dir="/root/Centos7-MOIPRO-AMD_fix_repo_kernelNew_opensource-driver/Kernel-4.14.0-1"
kernel_rpm1="kernel-ml-4.14.0-1.el7.elrepo.x86_64.rpm"
kernel_rpm2="kernel-ml-devel-4.14.0-1.el7.elrepo.x86_64.rpm"
kernel_rpm3="kernel-ml-headers-4.14.0-1.el7.elrepo.x86_64.rpm"

# Funkcija za uklanjanje postojecih kernel-ml paketa
remove_conflicting_packages() {
    echo "Uklanjam postojece kernel-ml pakete..."
    sudo rpm -e $(rpm -qa | grep "kernel-ml") --nodeps
}

# Funkcija za instalaciju novih kernel paketa
install_kernel_packages() {
    echo "Instaliram nove kernel pakete..."
    sudo rpm -ivh "$kernel_dir/$kernel_rpm1" && echo "prvi rijesen" 
    sudo rpm -ivh "$kernel_dir/$kernel_rpm2" && echo "drugi rijesen" 
    sudo rpm -ivh  "$kernel_dir/$kernel_rpm3" && echo "treci rijesen" 
    echo "Svi kernel paketi su uspešno instalirani."
    grub2-mkconfig -o /boot/grub2/grub.cfg
    grub2-set-default 0
    cp /root/Centos7-MOIPRO-AMD_fix_repo_kernelNew_opensource-driver/Missing-file-for-kernel-4.14.0-1/nospec.h /lib/modules/4.14.0-1.el7.elrepo.x86_64/build/include/linux/nospec.h && \
    reboot
    exit 1


}

# Proveri i ukloni stare kernel pakete
remove_conflicting_packages

# Instaliraj nove pakete
install_kernel_packages







