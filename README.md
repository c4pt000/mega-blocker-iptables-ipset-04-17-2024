
# requires "bullseye" in /etc/apt/sources.list
```
apt install xtables* libtext-csv-perl module-assistant -y 
module-assistant --verbose --text-mode auto-install xtables-addons 
sudo modprobe xt_geoip
mkdir /usr/share/xt_geoip

/usr/libexec/xtables-addons/xt_geoip_dl && /usr/libexec/xtables-addons/xt_geoip_build -D "/usr/share/xt_geoip" -S $(find . -type d -name "Geo*")
iptables -I INPUT -m geoip --src-cc VN -j DROP
iptables -A OUTPUT -m geoip --dst-cc VN -j DROP
```
