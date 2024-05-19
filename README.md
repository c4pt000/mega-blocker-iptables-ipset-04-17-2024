# script is designed to keep unwanted traffic out of apache2 or nginx web servers

# requires debian bullseye or ubuntu 20.04 (5.4+ kernel)

* sets are used from https://github.com/firehol/blocklist-ipsets and maxmind geolite2


* ip-reset.sh is a script to restore iptables to defaults and unload and remove all loaded ipsets

# review [system]-post-install.sh and either comment or uncomment block tor traffic

```
# this will block all tor-traffic "DO NOT USE IF YOU WANT TO USE THE TOR-BROWSER OR TORD OR TORRIFY ON YOUR HOST
# uncomment this line to block all tor traffic
# /etc/fail2ban/block-tor.sh
```

# debian bullseye
```
as root

wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/debian-pre-install.sh
wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/debian-post-install.sh

chmod +x debian-pre-install.sh
chmod +x debian-post-install.sh
./debian-pre-install.sh
./debian-post-install.sh

```

# ubuntu 20.04

```
as root

wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/ubuntu-pre-install.sh
wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/ubuntu-post-install.sh

chmod +x ubuntu-pre-install.sh
chmod +x ubuntu-post-install.sh
./ubuntu-pre-install.sh
./ubuntu-post-install.sh
```

# fedora 39

```
as root

wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/fedora39-pre-install.sh
wget https://raw.githubusercontent.com/c4pt000/mega-blocker-iptables-ipset-04-17-2024/main/fedora39-post-install.sh

chmod +x fedora39-pre-install.sh
chmod +x fedora39-post-install.sh
./fedora39-pre-install.sh
./fedora39-post-install.sh
```




# notes about this release below

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


# dropping and blocking for ALL tor traffic
```

 echo 'net.ipv6.conf.all.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
 echo 'net.ipv6.conf.default.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
 echo 'net.ipv6.conf.lo.disable_ipv6=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p



sudo apt install fail2ban -y
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

add to cron with crontab crontab -e

#Run the script periodically by adding the following lines to crontab -e (install cronic to be notified via email in case of script failure):

30 6 * * * /etc/fail2ban/block-tor.sh
```

# drop traffic and block data-centers, vpns, open-proxies, malicious ips, darknet ips using clearnet
```
sudo apt install ipset iprange netfilter-persistent -y
mkdir /root/blocklist
cd /root/blocklist
wget https://raw.githubusercontent.com/c4pt000/block-vietnam-ip-04-17-2024/main/ipset-apply.sh
sudo chmod +x ipset-apply.sh
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/geolite2_country/country_vn.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/datacenters.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/geolite2_country/anonymous.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/geolite2_country/satellite.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bruteforceblocker.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cybercrime.ipset
wget https://raw.githubusercontent.com/c4pt000/block-vietnam-ip-04-17-2024/main/new-vpn.ipset
./ipset-apply.sh country_vn.netset 
./ipset-apply.sh datacenters.netset
./ipset-apply.sh anonymous.netset
./ipset-apply.sh satellite.netset
./ipset-apply.sh bruteforceblocker.ipset
./ipset-apply.sh cybercrime.ipset
./ipset-apply.sh new-vpn.ipset


wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxylists.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxylists_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxylists_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxylists_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxyspy_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxyspy_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxyspy_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxz.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxz_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxz_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/proxz_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/socks_proxy.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/socks_proxy_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/socks_proxy_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/socks_proxy_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sslproxies.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sslproxies_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sslproxies_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sslproxies_7d.ipset

./ipset-apply.sh proxylists.ipset
./ipset-apply.sh proxylists_1d.ipset
./ipset-apply.sh proxylists_30d.ipset
./ipset-apply.sh proxylists_7d.ipset
./ipset-apply.sh proxyspy_1d.ipset
./ipset-apply.sh proxyspy_30d.ipset
./ipset-apply.sh proxyspy_7d.ipset
./ipset-apply.sh proxz.ipset
./ipset-apply.sh proxz_1d.ipset
./ipset-apply.sh proxz_30d.ipset
./ipset-apply.sh proxz_7d.ipset
./ipset-apply.sh socks_proxy.ipset
./ipset-apply.sh socks_proxy_1d.ipset
./ipset-apply.sh socks_proxy_30d.ipset
./ipset-apply.sh socks_proxy_7d.ipset
./ipset-apply.sh sslproxies.ipset
./ipset-apply.sh sslproxies_1d.ipset
./ipset-apply.sh sslproxies_30d.ipset
./ipset-apply.sh sslproxies_7d.ipset

wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/alienvault_reputation.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/asprox_c2.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_banjori.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_bebloh.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_c2.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_cl.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_cryptowall.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_dircrypt.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_dyre.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_geodo.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_hesperbot.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_matsnu.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_necurs.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_p2pgoz.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_pushdo.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_pykspa.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_qakbot.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_ramnit.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_ranbyus.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_simda.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_suppobox.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_symmi.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_tinba.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bambenek_volatile.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bbcan177_ms1.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bbcan177_ms3.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bds_atif.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_apache.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_bots.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_bruteforce.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_ftp.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_imap.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_mail.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_sip.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_ssh.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_de_strongips.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/blocklist_net_ua.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/botscout_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/botscout_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/botscout_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/botscout.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/botvrij_dst.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/botvrij_src.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/bruteforceblocker.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ciarmy.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cidr_report_bogons.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleanmx_phishing.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleanmx_viruses.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_new_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_new_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_new_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_new.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_top20.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_updated_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_updated_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_updated_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cleantalk_updated.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/coinbl_hosts_browser.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/coinbl_hosts.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/coinbl_hosts_optional.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/coinbl_ips.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cruzit_web_attacks.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/cta_cryptowall.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/darklist_de.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/datacenters.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dm_tor.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dshield_1d.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dshield_30d.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dshield_7d.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dshield.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dshield_top_1000.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/dyndns_ponmocup.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_14072015_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_14072015q_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_22072014a_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_22072014b_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_22072014c_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_atomictrivia_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_auth_update_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_burmundisoul_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_crazyerror_su.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_dagestanskiiviskis_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_differentia_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_disorderstatus_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_dorttlokolrt_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_downs1_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_ebankoalalusys_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_emptyarray_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_fioartd_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_getarohirodrons_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_hasanhashsde_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_inleet_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_islamislamdi_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_krnqlwlplttc_com.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_maddox1_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_manning1_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_misteryherson_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_mysebstarion_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_smartfoodsglutenfree_kz.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_venerologvasan93_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/esentire_volaya_ru.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_block.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_botcc.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_compromised.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_dshield.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_spamhaus.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/et_tor.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/feodo_badips.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/feodo.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_abusers_1d.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_abusers_30d.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_anonymous.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level2.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level3.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level4.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_proxies.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_webclient.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_webserver.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/gpf_comics.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/graphiclineweb.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/greensnow.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/haley_ssh.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_ats.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_emd.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_exp.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_fsa.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_grm.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_hfs.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_hjk.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_mmt.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_pha.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_psh.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/hphosts_wrz.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_abuse_palevo.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_abuse_spyeye.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_abuse_zeus.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_ciarmy_malicious.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_cidr_report_bogons.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_cruzit_web_attacks.netset

wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_malc0de.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_onion_router.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_activision.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_apple.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_blizzard.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_crowd_control.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_electronic_arts.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_joost.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_linden_lab.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_logmein.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_ncsoft.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_nintendo.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_pandora.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_pirate_bay.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_punkbuster.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_riot_games.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_sony_online.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_square_enix.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_steam.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_ubisoft.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_org_xfire.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_pedophiles.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_spamhaus_drop.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iblocklist_yoyo_adservers.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipblacklistcloud_recent_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipblacklistcloud_recent_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipblacklistcloud_recent_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipblacklistcloud_recent.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipblacklistcloud_top.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iw_spamlist.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/iw_wormlist.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/lashback_ubl.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/malc0de.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/malwaredomainlist.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/maxmind_proxy_fraud.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/myip.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/nixspam.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_attack.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_bruteforce.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_ddosbot.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_dnsscan.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_spam.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_suspicious.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_wannacry.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_webscan.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_all_wormscan.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_attack.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_bruteforce.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_ddosbot.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_dnsscan.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_spam.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_suspicious.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_wannacry.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_webscan.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/normshield_high_wormscan.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/nt_malware_dns.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/nt_malware_http.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/nt_malware_irc.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/nt_ssh_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/nullsecure.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/packetmail_emerging_ips.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/packetmail.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/packetmail_mail.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/packetmail_ramnode.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_commenters_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_commenters_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_commenters_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_commenters.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_dictionary_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_dictionary_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_dictionary_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_dictionary.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_harvesters_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_harvesters_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_harvesters_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_harvesters.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_spammers_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_spammers_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_spammers_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/php_spammers.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/pushing_inertia_blocklist.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_cryptowall_ps.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_feed.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_locky_c2.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_locky_ps.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_online.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_rw.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_teslacrypt_ps.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_torrentlocker_c2.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ransomware_torrentlocker_ps.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sblam.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/snort_ipfilter.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/spamhaus_drop.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/spamhaus_edrop.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sslbl_aggressive.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/sslbl.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_180d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_365d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_90d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/stopforumspam_toxic.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/taichung.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/talosintel_ipfilter.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/threatcrowd.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/tor_exits_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/tor_exits_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/tor_exits_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/tor_exits.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/turris_greylist.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_dns.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_ftp.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_http.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_mailer.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_malware.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_ntp.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_rdp.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_smb.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_spam.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_ssh.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_telnet.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_unspecified.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urandomusto_vnc.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/urlvir.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/uscert_hidden_cobra.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/voipbl.netset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/vxvault.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/xforce_bccs.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/xroxy_1d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/xroxy_30d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/xroxy_7d.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/xroxy.ipset
wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/yoyo_adservers.ipset


./ipset-apply.sh alienvault_reputation.ipset
./ipset-apply.sh asprox_c2.ipset
./ipset-apply.sh bambenek_banjori.ipset
./ipset-apply.sh bambenek_bebloh.ipset
./ipset-apply.sh bambenek_c2.ipset
./ipset-apply.sh bambenek_cl.ipset
./ipset-apply.sh bambenek_cryptowall.ipset
./ipset-apply.sh bambenek_dircrypt.ipset
./ipset-apply.sh bambenek_dyre.ipset
./ipset-apply.sh bambenek_geodo.ipset
./ipset-apply.sh bambenek_hesperbot.ipset
./ipset-apply.sh bambenek_matsnu.ipset
./ipset-apply.sh bambenek_necurs.ipset
./ipset-apply.sh bambenek_p2pgoz.ipset
./ipset-apply.sh bambenek_pushdo.ipset
./ipset-apply.sh bambenek_pykspa.ipset
./ipset-apply.sh bambenek_qakbot.ipset
./ipset-apply.sh bambenek_ramnit.ipset
./ipset-apply.sh bambenek_ranbyus.ipset
./ipset-apply.sh bambenek_simda.ipset
./ipset-apply.sh bambenek_suppobox.ipset
./ipset-apply.sh bambenek_symmi.ipset
./ipset-apply.sh bambenek_tinba.ipset
./ipset-apply.sh bambenek_volatile.ipset
./ipset-apply.sh bbcan177_ms1.netset
./ipset-apply.sh bbcan177_ms3.netset
./ipset-apply.sh bds_atif.ipset
./ipset-apply.sh blocklist_de_apache.ipset
./ipset-apply.sh blocklist_de_bots.ipset
./ipset-apply.sh blocklist_de_bruteforce.ipset
./ipset-apply.sh blocklist_de_ftp.ipset
./ipset-apply.sh blocklist_de_imap.ipset
./ipset-apply.sh blocklist_de.ipset
./ipset-apply.sh blocklist_de_mail.ipset
./ipset-apply.sh blocklist_de_sip.ipset
./ipset-apply.sh blocklist_de_ssh.ipset
./ipset-apply.sh blocklist_de_strongips.ipset
./ipset-apply.sh blocklist_net_ua.ipset
./ipset-apply.sh botscout_1d.ipset
./ipset-apply.sh botscout_30d.ipset
./ipset-apply.sh botscout_7d.ipset
./ipset-apply.sh botscout.ipset
./ipset-apply.sh botvrij_dst.ipset
./ipset-apply.sh botvrij_src.ipset
./ipset-apply.sh bruteforceblocker.ipset
./ipset-apply.sh ciarmy.ipset
./ipset-apply.sh cidr_report_bogons.netset
./ipset-apply.sh cleanmx_phishing.ipset
./ipset-apply.sh cleanmx_viruses.ipset
./ipset-apply.sh cleantalk_1d.ipset
./ipset-apply.sh cleantalk_30d.ipset
./ipset-apply.sh cleantalk_7d.ipset
./ipset-apply.sh cleantalk.ipset
./ipset-apply.sh cleantalk_new_1d.ipset
./ipset-apply.sh cleantalk_new_30d.ipset
./ipset-apply.sh cleantalk_new_7d.ipset
./ipset-apply.sh cleantalk_new.ipset
./ipset-apply.sh cleantalk_top20.ipset
./ipset-apply.sh cleantalk_updated_1d.ipset
./ipset-apply.sh cleantalk_updated_30d.ipset
./ipset-apply.sh cleantalk_updated_7d.ipset
./ipset-apply.sh cleantalk_updated.ipset
./ipset-apply.sh coinbl_hosts_browser.ipset
./ipset-apply.sh coinbl_hosts.ipset
./ipset-apply.sh coinbl_hosts_optional.ipset
./ipset-apply.sh coinbl_ips.ipset
./ipset-apply.sh cruzit_web_attacks.ipset
./ipset-apply.sh cta_cryptowall.ipset
./ipset-apply.sh darklist_de.netset
./ipset-apply.sh datacenters.netset
./ipset-apply.sh dm_tor.ipset
./ipset-apply.sh dshield_1d.netset
./ipset-apply.sh dshield_30d.netset
./ipset-apply.sh dshield_7d.netset
./ipset-apply.sh dshield.netset
./ipset-apply.sh dshield_top_1000.ipset
./ipset-apply.sh dyndns_ponmocup.ipset
./ipset-apply.sh esentire_14072015_com.ipset
./ipset-apply.sh esentire_14072015q_com.ipset
./ipset-apply.sh esentire_22072014a_com.ipset
./ipset-apply.sh esentire_22072014b_com.ipset
./ipset-apply.sh esentire_22072014c_com.ipset
./ipset-apply.sh esentire_atomictrivia_ru.ipset
./ipset-apply.sh esentire_auth_update_ru.ipset
./ipset-apply.sh esentire_burmundisoul_ru.ipset
./ipset-apply.sh esentire_crazyerror_su.ipset
./ipset-apply.sh esentire_dagestanskiiviskis_ru.ipset
./ipset-apply.sh esentire_differentia_ru.ipset
./ipset-apply.sh esentire_disorderstatus_ru.ipset
./ipset-apply.sh esentire_dorttlokolrt_com.ipset
./ipset-apply.sh esentire_downs1_ru.ipset
./ipset-apply.sh esentire_ebankoalalusys_ru.ipset
./ipset-apply.sh esentire_emptyarray_ru.ipset
./ipset-apply.sh esentire_fioartd_com.ipset
./ipset-apply.sh esentire_getarohirodrons_com.ipset
./ipset-apply.sh esentire_hasanhashsde_ru.ipset
./ipset-apply.sh esentire_inleet_ru.ipset
./ipset-apply.sh esentire_islamislamdi_ru.ipset
./ipset-apply.sh esentire_krnqlwlplttc_com.ipset
./ipset-apply.sh esentire_maddox1_ru.ipset
./ipset-apply.sh esentire_manning1_ru.ipset
./ipset-apply.sh esentire_misteryherson_ru.ipset
./ipset-apply.sh esentire_mysebstarion_ru.ipset
./ipset-apply.sh esentire_smartfoodsglutenfree_kz.ipset
./ipset-apply.sh esentire_venerologvasan93_ru.ipset
./ipset-apply.sh esentire_volaya_ru.ipset
./ipset-apply.sh et_block.netset
./ipset-apply.sh et_botcc.ipset
./ipset-apply.sh et_compromised.ipset
./ipset-apply.sh et_dshield.netset
./ipset-apply.sh et_spamhaus.netset
./ipset-apply.sh et_tor.ipset
./ipset-apply.sh feodo_badips.ipset
./ipset-apply.sh feodo.ipset
./ipset-apply.sh file-list.txt
./ipset-apply.sh firehol_abusers_1d.netset
./ipset-apply.sh firehol_abusers_30d.netset
./ipset-apply.sh firehol_anonymous.netset
./ipset-apply.sh firehol_level1.netset
./ipset-apply.sh firehol_level2.netset
./ipset-apply.sh firehol_level3.netset
./ipset-apply.sh firehol_level4.netset
./ipset-apply.sh firehol_proxies.netset
./ipset-apply.sh firehol_webclient.netset
./ipset-apply.sh firehol_webserver.netset
./ipset-apply.sh gpf_comics.ipset
./ipset-apply.sh graphiclineweb.netset
./ipset-apply.sh greensnow.ipset
./ipset-apply.sh haley_ssh.ipset
./ipset-apply.sh hphosts_ats.ipset
./ipset-apply.sh hphosts_emd.ipset
./ipset-apply.sh hphosts_exp.ipset
./ipset-apply.sh hphosts_fsa.ipset
./ipset-apply.sh hphosts_grm.ipset
./ipset-apply.sh hphosts_hfs.ipset
./ipset-apply.sh hphosts_hjk.ipset
./ipset-apply.sh hphosts_mmt.ipset
./ipset-apply.sh hphosts_pha.ipset
./ipset-apply.sh hphosts_psh.ipset
./ipset-apply.sh hphosts_wrz.ipset
./ipset-apply.sh iblocklist_abuse_palevo.netset
./ipset-apply.sh iblocklist_abuse_spyeye.netset
./ipset-apply.sh iblocklist_abuse_zeus.netset
./ipset-apply.sh iblocklist_ciarmy_malicious.netset
./ipset-apply.sh iblocklist_cidr_report_bogons.netset
./ipset-apply.sh iblocklist_cruzit_web_attacks.netset

./ipset-apply.sh iblocklist_malc0de.netset
./ipset-apply.sh iblocklist_onion_router.netset
./ipset-apply.sh iblocklist_org_activision.netset
./ipset-apply.sh iblocklist_org_apple.netset
./ipset-apply.sh iblocklist_org_blizzard.netset
./ipset-apply.sh iblocklist_org_crowd_control.netset
./ipset-apply.sh iblocklist_org_electronic_arts.netset
./ipset-apply.sh iblocklist_org_joost.netset
./ipset-apply.sh iblocklist_org_linden_lab.netset
./ipset-apply.sh iblocklist_org_logmein.netset
./ipset-apply.sh iblocklist_org_ncsoft.netset
./ipset-apply.sh iblocklist_org_nintendo.netset
./ipset-apply.sh iblocklist_org_pandora.netset
./ipset-apply.sh iblocklist_org_pirate_bay.netset
./ipset-apply.sh iblocklist_org_punkbuster.netset
./ipset-apply.sh iblocklist_org_riot_games.netset
./ipset-apply.sh iblocklist_org_sony_online.netset
./ipset-apply.sh iblocklist_org_square_enix.netset
./ipset-apply.sh iblocklist_org_steam.netset
./ipset-apply.sh iblocklist_org_ubisoft.netset
./ipset-apply.sh iblocklist_org_xfire.netset
./ipset-apply.sh iblocklist_pedophiles.netset
./ipset-apply.sh iblocklist_spamhaus_drop.netset
./ipset-apply.sh iblocklist_yoyo_adservers.netset
./ipset-apply.sh ip2location_country
./ipset-apply.sh ipblacklistcloud_recent_1d.ipset
./ipset-apply.sh ipblacklistcloud_recent_30d.ipset
./ipset-apply.sh ipblacklistcloud_recent_7d.ipset
./ipset-apply.sh ipblacklistcloud_recent.ipset
./ipset-apply.sh ipblacklistcloud_top.ipset
./ipset-apply.sh ipip_country
./ipset-apply.sh iw_spamlist.ipset
./ipset-apply.sh iw_wormlist.ipset
./ipset-apply.sh lashback_ubl.ipset
./ipset-apply.sh malc0de.ipset
./ipset-apply.sh malwaredomainlist.ipset
./ipset-apply.sh maxmind_proxy_fraud.ipset
./ipset-apply.sh myip.ipset
./ipset-apply.sh nixspam.ipset
./ipset-apply.sh normshield_all_attack.ipset
./ipset-apply.sh normshield_all_bruteforce.ipset
./ipset-apply.sh normshield_all_ddosbot.ipset
./ipset-apply.sh normshield_all_dnsscan.ipset
./ipset-apply.sh normshield_all_spam.ipset
./ipset-apply.sh normshield_all_suspicious.ipset
./ipset-apply.sh normshield_all_wannacry.ipset
./ipset-apply.sh normshield_all_webscan.ipset
./ipset-apply.sh normshield_all_wormscan.ipset
./ipset-apply.sh normshield_high_attack.ipset
./ipset-apply.sh normshield_high_bruteforce.ipset
./ipset-apply.sh normshield_high_ddosbot.ipset
./ipset-apply.sh normshield_high_dnsscan.ipset
./ipset-apply.sh normshield_high_spam.ipset
./ipset-apply.sh normshield_high_suspicious.ipset
./ipset-apply.sh normshield_high_wannacry.ipset
./ipset-apply.sh normshield_high_webscan.ipset
./ipset-apply.sh normshield_high_wormscan.ipset
./ipset-apply.sh nt_malware_dns.ipset
./ipset-apply.sh nt_malware_http.ipset
./ipset-apply.sh nt_malware_irc.ipset
./ipset-apply.sh nt_ssh_7d.ipset
./ipset-apply.sh nullsecure.ipset
./ipset-apply.sh packetmail_emerging_ips.ipset
./ipset-apply.sh packetmail.ipset
./ipset-apply.sh packetmail_mail.ipset
./ipset-apply.sh packetmail_ramnode.ipset
./ipset-apply.sh php_commenters_1d.ipset
./ipset-apply.sh php_commenters_30d.ipset
./ipset-apply.sh php_commenters_7d.ipset
./ipset-apply.sh php_commenters.ipset
./ipset-apply.sh php_dictionary_1d.ipset
./ipset-apply.sh php_dictionary_30d.ipset
./ipset-apply.sh php_dictionary_7d.ipset
./ipset-apply.sh php_dictionary.ipset
./ipset-apply.sh php_harvesters_1d.ipset
./ipset-apply.sh php_harvesters_30d.ipset
./ipset-apply.sh php_harvesters_7d.ipset
./ipset-apply.sh php_harvesters.ipset
./ipset-apply.sh php_spammers_1d.ipset
./ipset-apply.sh php_spammers_30d.ipset
./ipset-apply.sh php_spammers_7d.ipset
./ipset-apply.sh php_spammers.ipset
./ipset-apply.sh pushing_inertia_blocklist.netset
./ipset-apply.sh ransomware_cryptowall_ps.ipset
./ipset-apply.sh ransomware_feed.ipset
./ipset-apply.sh ransomware_locky_c2.ipset
./ipset-apply.sh ransomware_locky_ps.ipset
./ipset-apply.sh ransomware_online.ipset
./ipset-apply.sh ransomware_rw.ipset
./ipset-apply.sh ransomware_teslacrypt_ps.ipset
./ipset-apply.sh ransomware_torrentlocker_c2.ipset
./ipset-apply.sh ransomware_torrentlocker_ps.ipset
./ipset-apply.sh sblam.ipset
./ipset-apply.sh snort_ipfilter.ipset
./ipset-apply.sh spamhaus_drop.netset
./ipset-apply.sh spamhaus_edrop.netset
./ipset-apply.sh sslbl_aggressive.ipset
./ipset-apply.sh sslbl.ipset
./ipset-apply.sh stopforumspam_180d.ipset
./ipset-apply.sh stopforumspam_1d.ipset
./ipset-apply.sh stopforumspam_30d.ipset
./ipset-apply.sh stopforumspam_365d.ipset
./ipset-apply.sh stopforumspam_7d.ipset
./ipset-apply.sh stopforumspam_90d.ipset
./ipset-apply.sh stopforumspam.ipset
./ipset-apply.sh stopforumspam_toxic.netset
./ipset-apply.sh taichung.ipset
./ipset-apply.sh talosintel_ipfilter.ipset
./ipset-apply.sh threatcrowd.ipset
./ipset-apply.sh tor_exits_1d.ipset
./ipset-apply.sh tor_exits_30d.ipset
./ipset-apply.sh tor_exits_7d.ipset
./ipset-apply.sh tor_exits.ipset
./ipset-apply.sh turris_greylist.ipset
./ipset-apply.sh urandomusto_dns.ipset
./ipset-apply.sh urandomusto_ftp.ipset
./ipset-apply.sh urandomusto_http.ipset
./ipset-apply.sh urandomusto_mailer.ipset
./ipset-apply.sh urandomusto_malware.ipset
./ipset-apply.sh urandomusto_ntp.ipset
./ipset-apply.sh urandomusto_rdp.ipset
./ipset-apply.sh urandomusto_smb.ipset
./ipset-apply.sh urandomusto_spam.ipset
./ipset-apply.sh urandomusto_ssh.ipset
./ipset-apply.sh urandomusto_telnet.ipset
./ipset-apply.sh urandomusto_unspecified.ipset
./ipset-apply.sh urandomusto_vnc.ipset
./ipset-apply.sh urlvir.ipset
./ipset-apply.sh uscert_hidden_cobra.ipset
./ipset-apply.sh voipbl.netset
./ipset-apply.sh vxvault.ipset
./ipset-apply.sh xforce_bccs.ipset
./ipset-apply.sh xroxy_1d.ipset
./ipset-apply.sh xroxy_30d.ipset
./ipset-apply.sh xroxy_7d.ipset
./ipset-apply.sh xroxy.ipset
./ipset-apply.sh yoyo_adservers.ipset









 
```
