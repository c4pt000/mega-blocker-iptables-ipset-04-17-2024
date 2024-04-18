sudo apt install ipset iprange netfilter-persistent fail2ban xtables* libtext-csv-perl module-assistant -y 

mkdir /root/blocklist
cd /root/blocklist

module-assistant --verbose --text-mode auto-install xtables-addons 
sudo modprobe xt_geoip
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
/etc/fail2ban/block-tor.sh
