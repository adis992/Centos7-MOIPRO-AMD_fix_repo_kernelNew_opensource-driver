yum install -y wget
cd /usr/local/src
wget https://www.openssl.org/source/openssl-1.1.1h.tar.gz
yum install tar zip -y
tar -zxf openssl-1.1.1h.tar.gz

cd openssl-1.1.1h
./config
make
yum install -y perl-Test-Simple

make test
make install

ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1




openssl version



