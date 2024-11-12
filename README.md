https://sourceforge.net/projects/moiproamd/files/Release/moipro-amd-v2.0.0.4.zip/download

Ovo je firmware ova 2.0.0.4
mozes snimiti sa dd komandom na linuxu ili na win extract all i ides u folder home tu se nalazi rar cca 3.5gb njega extrakujes i nakon toga
instaliras bellena etcher i snimis na disk a fajl kada se extrakuje zauzima oko cca 30GB

System factory je verzija 2.0.0.1  tu imas isto i kompajlerske programe koje mozes preuzeti ovisno i verziji moi-a

Koristi ovaj redoslijed!

1.fix_repo_mv_repo.sh  (fix repo base, sclo, rh )
2.script_ssl-1.1-and_other_auto_install.sh (ssl-wget)
3.install_kernel_dependecies.sh  (or use curl for auto install from tbs)
4.drv-tbs.sh (driver skripta)
5.main_installer.sh (glavna skripta pokreni samo nju na isntaliranom sistemu MOIPRO-AMD)
