
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


# ubuntu

root@vmi1553553:~# 

```
apt install xtables* libtext-csv-perl module-assistant -y 
module-assistant --verbose --text-mode auto-install xtables-addons 
sudo modprobe xt_geoip
mkdir /usr/share/xt_geoip

chmod -R 777 /usr/lib/xtables-addons

/usr/lib/xtables-addons/xt_geoip_dl && /usr/lib/xtables-addons/xt_geoip_build -D "/usr/share/xt_geoip" -S $(find . -type d -name "Geo*")
iptables -I INPUT -m geoip --src-cc VN -j DROP
iptables -A OUTPUT -m geoip --dst-cc VN -j DROP
```


# dropping tor traffic
```

 echo 'net.ipv6.conf.all.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
 echo 'net.ipv6.conf.default.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
 echo 'net.ipv6.conf.lo.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p



sudo apt install fail2ban
Create a new fail2ban jail (editing /etc/fail2ban/jail.local):
[tor]
enabled  = true
bantime  = 25h
action   = iptables-allports[name=fail2banTOR, protocol=all]
Create a dummy filter file to /etc/fail2ban/filter.d/tor.conf:
[Definition]
failregex =
ignoreregex =

#optinalal
#Adjust fail2ban file limits (create /etc/systemd/system/fail2ban.service.d/limits.conf):
#[Service]
#LimitNOFILE=2048

#Restart systemctl and fail2ban:


sudo systemctl daemon-reload
sudo service fail2ban restart
sudo systemctl enable fail2ban

#Create a bash script to download the list of tor exit nodes and add their ips to the fail2ban jail:



#!/bin/bash
set -o nounset -o xtrace -o errexit

IPV4_REGEX='^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$'
IPV6_REGEX='^s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:)))(%.+)?s*(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))?$'

banned_ip_counter=0

for ip in $(curl -fsS https://check.torproject.org/torbulkexitlist); do
  if ! [[ $ip =~ $IPV4_REGEX || $ip =~ $IPV6_REGEX ]]; then
      echo "Error: $ip is not a valid IPv4/IPv6 address" >&2
      continue
  fi

  sudo fail2ban-client set "tor" banip "$ip"
  banned_ip_counter="$((banned_ip_counter+1))"
done

if [[ $banned_ip_counter -lt 1 ]]; then
  echo "Error: no IP banned" >&2
fi

#Run the script periodically by adding the following lines to crontab -e (install cronic to be notified via email in case of script failure):

30 6 * * * cronic /etc/fail2ban/block-tor.sh
```
