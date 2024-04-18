mkdir /root/blocklist
cd /root/blocklist

git clone https://github.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024
cd mega-blocker-iptables-ipset-04-17-2024

wget https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-39.noarch.rpm
wget https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-39.noarch.rpm
rpm -Uvh --force --nodeps rpmfusion*rpm

yum download akmods kmodtool akmod-xtables-addons ipset xtables-addons kmod-xtables-addons iptables-devel fail2ban

rpm -Uvh --force --nodeps *rpm
cd xtables-addons-3.26/
./configure
make -j24
make -j24 install
depmod -a
modprobe xt_geoip
cd ../..

sudo mkdir -p /usr/share/xt_geoip


echo 'net.ipv6.conf.all.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
 echo 'net.ipv6.conf.default.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
 echo 'net.ipv6.conf.lo.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p




wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/jail.local
sudo cp -rf jail.local /etc/fail2ban/jail.local
wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/tor.conf
sudo cp -rf tor.conf /etc/fail2ban/filter.d/tor.conf



sudo systemctl daemon-reload
sudo service fail2ban restart
sudo systemctl enable fail2ban

wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/block-tor.sh
sudo cp -rf block-tor.sh /etc/fail2ban/block-tor.sh
sudo chmod +x /etc/fail2ban/block-tor.sh

