#!/bin/sh
# 判定是否为ap模式
eth_count=$(ls /sys/class/net | grep -c "eth")
port_count=$(uci show network | grep "network.@device\[0\].ports=" | tr ' ' '\n' | grep -c "eth")
if [ "$port_count" -eq "$eth_count" ] && [ "$(uci show dhcp | grep -c "dhcp.lan.ignore='1'")" -eq "1" ] && [ "$(uci show dhcp | grep -c "dhcp.lan.dhcpv6")" -eq 0 ]; then
  echo "Skip modify lan ip"
else
  uci set network.lan.ipaddr="192.168.1.1"
  uci commit network
  /etc/init.d/network restart
fi
# 判定是否为ap模式
sleep 2
if [ "$( opkg list-installed 2>/dev/null| grep -c "^luci-app-fancontrol")" -ne '0' ];then
  uci set fancontrol.settings.enabled='1'
  uci set fancontrol.settings.start_speed='55'
  uci set fancontrol.settings.start_temp='65'
  uci commit fancontrol
  /etc/init.d/fancontrol restart
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^luci-app-tailscale")" -ne '0' ] && [ "$( cat /etc/board.json | grep -c "gl-mt3000")" -ne '0' ];then
  if [ "$( opkg list-installed 2>/dev/null| grep -c "^firewall4")" -eq '1' ];then
    uci set tailscale.settings.fw_mode='nftables'
  else
    uci set tailscale.settings.fw_mode='iptables'
  fi
  uci del tailscale.settings.access
  uci add_list tailscale.settings.access='tsfwlan'
  uci add_list tailscale.settings.access='tsfwwan'
  uci add_list tailscale.settings.access='lanfwts'
  uci add_list tailscale.settings.access='wanfwts'
  uci set tailscale.settings.enabled='1'
  uci set tailscale.settings.port='41650'
  uci set tailscale.settings.config_path='/etc/tailscale'
  uci set tailscale.settings.log_stdout='1'
  uci set tailscale.settings.log_stderr='1'
  uci set tailscale.settings.acceptRoutes='0'
  uci set tailscale.settings.hostname='gl-mt3000'
  uci set tailscale.settings.acceptDNS='1'
  uci set tailscale.settings.advertiseExitNode='1'
  uci commit tailscale
  /etc/init.d/tailscale restart
  uci set firewall.tszone.forward='ACCEPT'
  uci commit firewall
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^luci-app-tailscale")" -ne '0' ] && [ "$( cat /etc/openwrt_release | grep -c "x86_64")" -ne '0' ];then
  if [ "$( opkg list-installed 2>/dev/null| grep -c "^firewall4")" -eq '1' ];then
    uci set tailscale.settings.fw_mode='nftables'
  else
    uci set tailscale.settings.fw_mode='iptables'
  fi
  uci set tailscale.settings.enabled='1'
  uci set tailscale.settings.port='41641'
  uci set tailscale.settings.config_path='/etc/tailscale'
  uci set tailscale.settings.log_stdout='1'
  uci set tailscale.settings.log_stderr='1'
  uci set tailscale.settings.acceptRoutes='0'
  uci set tailscale.settings.hostname='openwrt'
  uci set tailscale.settings.acceptDNS='1'
  uci set tailscale.settings.advertiseExitNode='1'
  uci commit tailscale
  /etc/init.d/tailscale restart
  uci set firewall.tszone.forward='ACCEPT'
  uci commit firewall
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^mosdns")" -ne '0' ];then
  uci set mosdns.config.enabled='1'
  uci set mosdns.config.redirect='0'
  uci set mosdns.config.custom_local_dns='1'
  uci set mosdns.config.enable_http3_local='0'
  uci set mosdns.config.dns_leak='1'
  uci add_list mosdns.config.local_dns='https://dns.alidns.com/dns-query'
  uci add_list mosdns.config.local_dns='https://doh.pub/dns-query'
  uci add_list mosdns.config.local_dns='https://doh.360.cn/dns-query'
  uci add_list mosdns.config.remote_dns='https://doh.opendns.com/dns-query'
  uci add_list mosdns.config.remote_dns='https://dns.google/dns-query'
  uci add_list mosdns.config.remote_dns='https://dns.cloudflare.com/dns-query'
  uci add_list mosdns.config.remote_dns='https://dns.quad9.net/dns-query'
  uci commit mosdns
  /etc/init.d/mosdns restart
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^aria2")" -ne '0' ];then
  uci set aria2.main.user='root'
  uci set aria2.main.config_dir='/etc/aria2'
  uci set aria2.main.log='/etc/aria2/log'
  uci set aria2.main.log_level='notice'
  uci set aria2.main.ca_certificate='/etc/ssl/cert.pem'
  uci set aria2.main.bt_tracker='http://1337.abcvg.info:80/announce,http://207.241.226.111:6969/announce,http://207.241.231.226:6969/announce,http://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,http://[2a04:ac00:1:3dd8::1:2710]:2710/announce,http://bt.endpot.com:80/announce,http://bt.okmp3.ru:2710/announce,http://chouchou.top:8080/announce,http://fe.dealclub.de:6969/announce,http://montreal.nyap2p.com:8080/announce,http://movies.zsw.ca:6969/announce,http://nyaa.tracker.wf:7777/announce,http://open.acgnxtracker.com:80/announce,http://open.tracker.ink:6969/announce,http://p2p.0g.cx:6969/announce,http://parag.rs:6969/announce,http://retracker.hotplug.ru:2710/announce,http://share.camoe.cn:8080/announce,http://t.acg.rip:6699/announce,http://torrentsmd.com:8080/announce,http://tr.cili001.com:8070/announce,http://tracker.birkenwald.de:6969/announce,http://tracker.bt4g.com:2095/announce,http://tracker.dler.com:6969/announce,http://tracker.dler.org:6969/announce,http://tracker.edkj.club:6969/announce,http://tracker.files.fm:6969/announce,http://tracker.gbitt.info:80/announce,http://tracker.ipv6tracker.ru:80/announce,http://tracker.mywaifu.best:6969/announce,http://tracker.opentrackr.org:1337/announce,http://tracker.qu.ax:6969/announce,http://tracker.renfei.net:8080/announce,http://tracker.srv00.com:6969/announce,http://tracker.swateam.org.uk:2710/announce,http://tracker2.dler.org:80/announce,http://v6-tracker.0g.cx:6969/announce,http://vps-dd0a0715.vps.ovh.net:6969/announce,http://wepzone.net:6969/announce,http://www.all4nothin.net:80/announce.php,http://www.peckservers.com:9000/announce,http://www.wareztorrent.com:80/announce,https://1337.abcvg.info:443/announce,https://opentracker.i2p.rocks:443/announce,https://t.zerg.pw:443/announce,https://t1.hloli.org:443/announce,https://tr.burnabyhighstar.com:443/announce,https://tr.ready4.icu:443/announce,https://tracker.foreverpirates.co:443/announce,https://tracker.gbitt.info:443/announce,https://tracker.imgoingto.icu:443/announce,https://tracker.jiesen.life:8443/announce,https://tracker.kuroy.me:443/announce,https://tracker.lilithraws.cf:443/announce,https://tracker.lilithraws.org:443/announce,https://tracker.logirl.moe:443/announce,https://tracker.loligirl.cn:443/announce,https://tracker.tamersunion.org:443/announce,https://tracker1.520.jp:443/announce,udp://184.105.151.166:6969/announce,udp://207.241.226.111:6969/announce,udp://207.241.231.226:6969/announce,udp://52.58.128.163:6969/announce,udp://9.rarbg.com:2810/announce,udp://91.216.110.52:451/announce,udp://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,udp://[2001:470:1:189:0:1:2:3]:6969/announce,udp://[2a03:7220:8083:cd00::1]:451/announce,udp://[2a04:ac00:1:3dd8::1:2710]:2710/announce,udp://[2a0f:e586:f:f::81]:6969/announce,udp://aarsen.me:6969/announce,udp://acxx.de:6969/announce,udp://aegir.sexy:6969/announce,udp://astrr.ru:6969/announce,udp://bedro.cloud:6969/announce,udp://black-bird.ynh.fr:6969/announce,udp://boysbitte.be:6969/announce,udp://bt.ktrackers.com:6666/announce,udp://bt1.archive.org:6969/announce,udp://bt2.archive.org:6969/announce,udp://chouchou.top:8080/announce,udp://concen.org:6969/announce,udp://epider.me:6969/announce,udp://exodus.desync.com:6969/announce,udp://fe.dealclub.de:6969/announce,udp://fh2.cmp-gaming.com:6969/announce,udp://freedom.1776.ga:6969/announce,udp://htz3.noho.st:6969/announce,udp://inferno.demonoid.is:3391/announce,udp://ipv6.tracker.monitorit4.me:6969/announce,udp://laze.cc:6969/announce,udp://linfan.moe:6969/announce,udp://mail.artixlinux.org:6969/announce,udp://moonburrow.club:6969/announce,udp://movies.zsw.ca:6969/announce,udp://new-line.net:6969/announce,udp://open.demonii.com:1337/announce,udp://open.dstud.io:6969/announce,udp://open.stealth.si:80/announce,udp://open.tracker.ink:6969/announce,udp://opentor.org:2710/announce,udp://opentracker.i2p.rocks:6969/announce,udp://opentracker.io:6969/announce,udp://p4p.arenabg.com:1337/announce,udp://private.anonseed.com:6969/announce,udp://psyco.fr:6969/announce,udp://public.publictracker.xyz:6969/announce,udp://public.tracker.vraphim.com:6969/announce,udp://rep-art.ynh.fr:6969/announce,udp://retracker.hotplug.ru:2710/announce,udp://retracker.lanta-net.ru:2710/announce,udp://retracker01-msk-virt.corbina.net:80/announce,udp://run.publictracker.xyz:6969/announce,udp://ryjer.com:6969/announce,udp://sanincode.com:6969/announce,udp://stargrave.org:6969/announce,udp://static.54.161.216.95.clients.your-server.de:6969/announce,udp://t.133335.xyz:6969/announce,udp://t.zerg.pw:6969/announce,udp://tamas3.ynh.fr:6969/announce,udp://thagoat.rocks:6969/announce,udp://thinking.duckdns.org:6969/announce,udp://thouvenin.cloud:6969/announce,udp://torrents.artixlinux.org:6969/announce,udp://tr.bangumi.moe:6969/announce,udp://tr.cili001.com:8070/announce,udp://tr2.cubonegro.lol:6969/announce,udp://tracker-udp.gbitt.info:80/announce,udp://tracker.4.babico.name.tr:3131/announce,udp://tracker.altrosky.nl:6969/announce,udp://tracker.arcbox.cc:6969/announce,udp://tracker.artixlinux.org:6969/announce,udp://tracker.auctor.tv:6969/announce,udp://tracker.beeimg.com:6969/announce,udp://tracker.birkenwald.de:6969/announce,udp://tracker.bitsearch.to:1337/announce,udp://tracker.bittor.pw:1337/announce,udp://tracker.cubonegro.lol:6969/announce,udp://tracker.cyberia.is:6969/announce,udp://tracker.dler.com:6969/announce,udp://tracker.dler.org:6969/announce,udp://tracker.filemail.com:6969/announce,udp://tracker.jonaslsa.com:6969/announce,udp://tracker.joybomb.tw:6969/announce,udp://tracker.leech.ie:1337/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.monitorit4.me:6969/announce,udp://tracker.openbittorrent.com:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://tracker.pimpmyworld.to:6969/announce,udp://tracker.qu.ax:6969/announce,udp://tracker.skyts.net:6969/announce,udp://tracker.srv00.com:6969/announce,udp://tracker.swateam.org.uk:2710/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker1.myporn.club:9337/announce,udp://tracker2.dler.com:80/announce,udp://tracker2.dler.org:80/announce,udp://tracker6.lelux.fi:6969/announce,udp://trackerb.jonaslsa.com:6969/announce,udp://u4.trakx.crim.ist:1337/announce,udp://u6.trakx.crim.ist:1337/announce,udp://uploads.gamecoast.net:6969/announce,udp://v1046920.hosted-by-vdsina.ru:6969/announce,udp://v2.iperson.xyz:6969/announce,udp://wepzone.net:6969/announce,udp://www.peckservers.com:9000/announce,udp://www.torrent.eu.org:451/announce,udp://zecircle.xyz:6969/announce,ws://hub.bugout.link:80/announce,wss://tracker.openwebtorrent.com:443/announce'
  uci commit aria2
  /etc/init.d/aria2 restart
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^dnsmasq")" -ne '0' ];then
  uci set dhcp.@dnsmasq[0].cachesize='0'
  uci commit dhcp
  /etc/init.d/dnsmasq restart
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^luci-app-openclash")" -ne '0' ] && [ "$(uci show openclash|grep -c ".port='5335'")" -ne '8' ];then
  if [ "$(grep -c "^直连规则(by 沉默の金)" /usr/share/openclash/res/rule_providers.list)" -eq '0' ];then
      sed -i '1i 直连规则(by 沉默の金),沉默の金,classical,chenmozhijin/OpenWrt-K/main/files/etc/openclash/rule_provider/,DirectRule-chenmozhijin.yaml' "/usr/share/openclash/res/rule_providers.list"
  fi
  if [ "$( opkg list-installed 2>/dev/null| grep -c "^luci-app-mosdns")" -ne '0' ];then
    n=0
    while [ "$n" -lt $(uci show openclash|grep -c "^openclash.@dns_servers\[[0-9]\{1,10\}\]=dns_servers") ]; do
      uci set openclash.@dns_servers[$n].enabled='0'
      n=$((n + 1))
    done
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-1].enabled='1'
    uci set openclash.@dns_servers[-1].group='nameserver'
    uci set openclash.@dns_servers[-1].type='udp'
    uci set openclash.@dns_servers[-1].ip='127.0.0.1'
    uci set openclash.@dns_servers[-1].port='5335'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-1].enabled='1'
    uci set openclash.@dns_servers[-1].group='fallback'
    uci set openclash.@dns_servers[-1].type='udp'
    uci set openclash.@dns_servers[-1].ip='127.0.0.1'
    uci set openclash.@dns_servers[-1].port='5335'
    uci set openclash.config.enable_custom_dns='1'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-2].enabled='1'
    uci set openclash.@dns_servers[-2].group='nameserver'
    uci set openclash.@dns_servers[-2].type='tcp'
    uci set openclash.@dns_servers[-2].ip='127.0.0.1'
    uci set openclash.@dns_servers[-2].port='5335'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-2].enabled='1'
    uci set openclash.@dns_servers[-2].group='fallback'
    uci set openclash.@dns_servers[-2].type='tcp'
    uci set openclash.@dns_servers[-2].ip='127.0.0.1'
    uci set openclash.@dns_servers[-2].port='5335'
    uci set openclash.config.enable_custom_dns='1'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-3].enabled='1'
    uci set openclash.@dns_servers[-3].group='nameserver'
    uci set openclash.@dns_servers[-3].type='tls'
    uci set openclash.@dns_servers[-3].ip='127.0.0.1'
    uci set openclash.@dns_servers[-3].port='5335'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-3].enabled='1'
    uci set openclash.@dns_servers[-3].group='fallback'
    uci set openclash.@dns_servers[-3].type='tls'
    uci set openclash.@dns_servers[-3].ip='127.0.0.1'
    uci set openclash.@dns_servers[-3].port='5335'
    uci set openclash.config.enable_custom_dns='1'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-4].enabled='1'
    uci set openclash.@dns_servers[-4].group='nameserver'
    uci set openclash.@dns_servers[-4].type='https'
    uci set openclash.@dns_servers[-4].ip='127.0.0.1'
    uci set openclash.@dns_servers[-4].port='5335'
    uci add openclash dns_servers
    uci set openclash.@dns_servers[-4].enabled='1'
    uci set openclash.@dns_servers[-4].group='fallback'
    uci set openclash.@dns_servers[-4].type='https'
    uci set openclash.@dns_servers[-4].ip='127.0.0.1'
    uci set openclash.@dns_servers[-4].port='5335'
    uci set openclash.config.enable_custom_dns='1'
  fi
  uci set openclash.config.enable_redirect_dns='1'
  uci set openclash.config.operation_mode='fake-ip'
  uci set openclash.config.en_mode='fake-ip-mix'
  uci delete openclash.config.enable_udp_proxy='1'
  uci set openclash.config.ipv6_enable='1'
  uci set openclash.config.ipv6_dns='1'
  uci set openclash.config.other_rule_auto_update='1'
  uci set openclash.config.stack_type='system'
  uci set openclash.config.enable_custom_domain_dns_server='0'
  uci set openclash.config.china_ip_route='1'
  uci set openclash.config.other_rule_update_week_time='*'
  uci set openclash.config.other_rule_update_day_time='0'
  uci set openclash.config.geo_auto_update='1'
  uci set openclash.config.geo_update_week_time='*'
  uci set openclash.config.geo_update_day_time='1'
  uci set openclash.config.geoip_auto_update='1'
  uci set openclash.config.geoip_update_week_time='*'
  uci set openclash.config.geoip_update_day_time='3'
  uci set openclash.config.geosite_auto_update='1'
  uci set openclash.config.geosite_update_week_time='*'
  uci set openclash.config.geosite_update_day_time='4'
  uci set openclash.config.chnr_auto_update='1'
  uci set openclash.config.chnr_update_week_time='1'
  uci set openclash.config.chnr_update_day_time='5'
  uci set openclash.config.auto_restart='0'
  uci set openclash.config.auto_restart_week_time='1'
  uci set openclash.config.auto_restart_day_time='0'
  uci set openclash.config.ipv6_mode='2'
  uci set openclash.config.enable_v6_udp_proxy='1'
  uci set openclash.config.china_ip6_route='1'
  if [ "$( uci show openclash| grep -c "/m0eak/clash-rules/main/rule-provider/direct.txt")" -eq '0' ];then
    uci add openclash rule_providers
    uci set openclash.@rule_providers[-1]=rule_providers
    uci set openclash.@rule_providers[-1].enabled='1'
    uci set openclash.@rule_providers[-1].config='all'
    uci set openclash.@rule_providers[-1].name='Custom-Rules-Direct'
    uci set openclash.@rule_providers[-1].type='http'
    uci set openclash.@rule_providers[-1].behavior='domain'
    uci set openclash.@rule_providers[-1].format='text'
    uci set openclash.@rule_providers[-1].url='https://raw.githubusercontent.com/m0eak/clash-rules/main/rule-provider/direct.txt'
    uci set openclash.@rule_providers[-1].interval='3600'
    uci set openclash.@rule_providers[-1].position='0'
    uci set openclash.@rule_providers[-1].group='DIRECT'
  fi
  uci commit openclash
fi
if [ "$( opkg list-installed 2>/dev/null| grep -c "^smartdns")" -ne '0' ] && [ ! "$(uci -q get smartdns.@server[0].name)" = "清华大学TUNA协会" ];then
  uci set smartdns.@smartdns[0].prefetch_domain='1'
  uci set smartdns.@smartdns[0].port='6053'
  uci set smartdns.@smartdns[0].seconddns_port='5335'
  uci set smartdns.@smartdns[0].seconddns_no_rule_addr='0'
  uci set smartdns.@smartdns[0].seconddns_no_rule_nameserver='0'
  uci set smartdns.@smartdns[0].seconddns_no_rule_ipuci set='0'
  uci set smartdns.@smartdns[0].seconddns_no_rule_soa='0'
  uci set smartdns.@smartdns[0].tcp_server='1'
  uci set smartdns.@smartdns[0].rr_ttl='600'
  uci set smartdns.@smartdns[0].seconddns_enabled='1'
  uci set smartdns.@smartdns[0].server_name='smartdns-China'
  uci set smartdns.@smartdns[0].seconddns_tcp_server='1'
  uci set smartdns.@smartdns[0].seconddns_server_group='smartdns-Overseas'
  uci set smartdns.@smartdns[0].rr_ttl_min='5'
  uci set smartdns.@smartdns[0].seconddns_no_speed_check='0'
  uci set smartdns.@smartdns[0].cache_size='190150'
  uci set smartdns.@smartdns[0].serve_expired='0'
  uci set smartdns.@smartdns[0].auto_set_dnsmasq='0'
  uci set smartdns.@smartdns[0].ipv6_server='1'
  uci set smartdns.@smartdns[0].dualstack_ip_selection='1'
  uci set smartdns.@smartdns[0].force_aaaa_soa='0'
  uci set smartdns.@smartdns[0].coredump='1'
  uci set smartdns.@smartdns[0].speed_check_mode='tcp:443,tcp:80,ping'
  uci set smartdns.@smartdns[0].resolve_local_hostnames='1'
  uci set smartdns.@smartdns[0].seconddns_force_aaaa_soa='0'
  uci set smartdns.@smartdns[0].enable_auto_update='0'
  uci set smartdns.@smartdns[0].enabled='1'
  uci set smartdns.@smartdns[0].bind_device='1'
  uci set smartdns.@smartdns[0].cache_persist='1'
  uci set smartdns.@smartdns[0].force_https_soa='0'
  uci set smartdns.@smartdns[0].seconddns_no_dualstack_selection='0'
  uci set smartdns.@smartdns[0].seconddns_no_cache='0'
  uci add smartdns server
  uci set smartdns.@server[0].enabled='1'
  uci set smartdns.@server[0].type='udp'
  uci set smartdns.@server[0].name='清华大学TUNA协会'
  uci set smartdns.@server[0].ip='101.6.6.6'
  uci set smartdns.@server[0].server_group='smartdns-China'
  uci set smartdns.@server[0].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[1].enabled='1'
  uci set smartdns.@server[1].type='udp'
  uci set smartdns.@server[1].name='114'
  uci set smartdns.@server[1].ip='114.114.114.114'
  uci set smartdns.@server[1].server_group='smartdns-China'
  uci set smartdns.@server[1].blacklist_ip='0'
  uci set smartdns.@server[1].port='53'
  uci add smartdns server
  uci set smartdns.@server[2].enabled='1'
  uci set smartdns.@server[2].type='udp'
  uci set smartdns.@server[2].name='ail dns ipv4'
  uci set smartdns.@server[2].ip='223.5.5.5'
  uci set smartdns.@server[2].port='53'
  uci set smartdns.@server[2].server_group='smartdns-China'
  uci set smartdns.@server[2].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[3].enabled='1'
  uci set smartdns.@server[3].name='Ali DNS'
  uci set smartdns.@server[3].ip='https://dns.alidns.com/dns-query'
  uci set smartdns.@server[3].type='https'
  uci set smartdns.@server[3].no_check_certificate='0'
  uci set smartdns.@server[3].server_group='smartdns-China'
  uci set smartdns.@server[3].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[4].enabled='1'
  uci set smartdns.@server[4].name='360 Secure DNS'
  uci set smartdns.@server[4].type='https'
  uci set smartdns.@server[4].no_check_certificate='0'
  uci set smartdns.@server[4].server_group='smartdns-China'
  uci set smartdns.@server[4].blacklist_ip='0'
  uci set smartdns.@server[4].ip='https://doh.360.cn/dns-query'
  uci add smartdns server
  uci set smartdns.@server[5].enabled='1'
  uci set smartdns.@server[5].name='DNSPod Public DNS+'
  uci set smartdns.@server[5].ip='https://doh.pub/dns-query'
  uci set smartdns.@server[5].type='https'
  uci set smartdns.@server[5].no_check_certificate='0'
  uci set smartdns.@server[5].server_group='smartdns-China'
  uci set smartdns.@server[5].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[6].enabled='1'
  uci set smartdns.@server[6].type='udp'
  uci set smartdns.@server[6].name='baidu dns'
  uci set smartdns.@server[6].ip='180.76.76.76'
  uci set smartdns.@server[6].port='53'
  uci set smartdns.@server[6].server_group='smartdns-China'
  uci set smartdns.@server[6].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[7].enabled='1'
  uci set smartdns.@server[7].type='udp'
  uci set smartdns.@server[7].name='360dns'
  uci set smartdns.@server[7].ip='101.226.4.6'
  uci set smartdns.@server[7].port='53'
  uci set smartdns.@server[7].server_group='smartdns-China'
  uci set smartdns.@server[7].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[8].enabled='1'
  uci set smartdns.@server[8].type='udp'
  uci set smartdns.@server[8].name='dnspod'
  uci set smartdns.@server[8].ip='119.29.29.29'
  uci set smartdns.@server[8].port='53'
  uci set smartdns.@server[8].blacklist_ip='0'
  uci set smartdns.@server[8].server_group='smartdns-China'
  uci add smartdns server
  uci set smartdns.@server[9].enabled='1'
  uci set smartdns.@server[9].name='Cloudflare-tls'
  uci set smartdns.@server[9].ip='1.1.1.1'
  uci set smartdns.@server[9].type='tls'
  uci set smartdns.@server[9].server_group='smartdns-Overseas'
  uci set smartdns.@server[9].exclude_default_group='0'
  uci set smartdns.@server[9].blacklist_ip='0'
  uci set smartdns.@server[9].no_check_certificate='0'
  uci set smartdns.@server[9].port='853'
  uci set smartdns.@server[9].spki_pin='GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg='
  uci add smartdns server
  uci set smartdns.@server[10].enabled='1'
  uci set smartdns.@server[10].name='Google_DNS-tls'
  uci set smartdns.@server[10].type='tls'
  uci set smartdns.@server[10].server_group='smartdns-Overseas'
  uci set smartdns.@server[10].exclude_default_group='0'
  uci set smartdns.@server[10].blacklist_ip='0'
  uci set smartdns.@server[10].no_check_certificate='0'
  uci set smartdns.@server[10].port='853'
  uci set smartdns.@server[10].ip='8.8.4.4'
  uci set smartdns.@server[10].spki_pin='r/fTokourI3+um9Rws4XrHG6fWEmHpZ8iWnOUjzwwjQ='
  uci add smartdns server
  uci set smartdns.@server[11].enabled='1'
  uci set smartdns.@server[11].name='Quad9-tls'
  uci set smartdns.@server[11].ip='9.9.9.9'
  uci set smartdns.@server[11].type='tls'
  uci set smartdns.@server[11].server_group='smartdns-Overseas'
  uci set smartdns.@server[11].exclude_default_group='0'
  uci set smartdns.@server[11].blacklist_ip='0'
  uci set smartdns.@server[11].no_check_certificate='0'
  uci set smartdns.@server[11].port='853'
  uci set smartdns.@server[11].spki_pin='/SlsviBkb05Y/8XiKF9+CZsgCtrqPQk5bh47o0R3/Cg='
  uci add smartdns server
  uci set smartdns.@server[12].enabled='1'
  uci set smartdns.@server[12].name='quad9-ipv6'
  uci set smartdns.@server[12].ip='2620:fe::fe'
  uci set smartdns.@server[12].port='9953'
  uci set smartdns.@server[12].type='udp'
  uci set smartdns.@server[12].server_group='smartdns-Overseas'
  uci set smartdns.@server[12].exclude_default_group='0'
  uci set smartdns.@server[12].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[13].enabled='1'
  uci set smartdns.@server[13].name='谷歌DNS'
  uci set smartdns.@server[13].ip='https://dns.google/dns-query'
  uci set smartdns.@server[13].type='https'
  uci set smartdns.@server[13].no_check_certificate='0'
  uci set smartdns.@server[13].server_group='smartdns-Overseas'
  uci set smartdns.@server[13].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[14].enabled='1'
  uci set smartdns.@server[14].name='Cloudflare DNS '
  uci set smartdns.@server[14].ip='https://dns.cloudflare.com/dns-query'
  uci set smartdns.@server[14].type='https'
  uci set smartdns.@server[14].no_check_certificate='0'
  uci set smartdns.@server[14].server_group='smartdns-Overseas'
  uci set smartdns.@server[14].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[15].enabled='1'
  uci set smartdns.@server[15].name='CIRA Canadian Shield DNS'
  uci set smartdns.@server[15].ip='https://private.canadianshield.cira.ca/dns-query'
  uci set smartdns.@server[15].type='https'
  uci set smartdns.@server[15].no_check_certificate='0'
  uci set smartdns.@server[15].server_group='smartdns-Overseas'
  uci set smartdns.@server[15].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[16].enabled='1'
  uci set smartdns.@server[16].name='Restena DNS'
  uci set smartdns.@server[16].ip='https://kaitain.restena.lu/dns-query'
  uci set smartdns.@server[16].type='https'
  uci set smartdns.@server[16].no_check_certificate='0'
  uci set smartdns.@server[16].server_group='smartdns-Overseas'
  uci set smartdns.@server[16].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[17].enabled='1'
  uci set smartdns.@server[17].name='Quad9 DNS'
  uci set smartdns.@server[17].ip='https://dns.quad9.net/dns-query'
  uci set smartdns.@server[17].type='https'
  uci set smartdns.@server[17].no_check_certificate='0'
  uci set smartdns.@server[17].server_group='smartdns-Overseas'
  uci set smartdns.@server[17].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[18].enabled='1'
  uci set smartdns.@server[18].name='CZ.NIC ODVR'
  uci set smartdns.@server[18].ip='https://odvr.nic.cz/doh'
  uci set smartdns.@server[18].type='https'
  uci set smartdns.@server[18].no_check_certificate='0'
  uci set smartdns.@server[18].server_group='smartdns-Overseas'
  uci set smartdns.@server[18].blacklist_ip='0'
  uci add smartdns server
  uci set smartdns.@server[19].enabled='1'
  uci set smartdns.@server[19].name='AhaDNS-Spain'
  uci set smartdns.@server[19].ip='https://doh.es.ahadns.net/dns-query '
  uci set smartdns.@server[19].type='https'
  uci set smartdns.@server[19].no_check_certificate='0'
  uci set smartdns.@server[19].server_group='smartdns-Overseas'
  uci set smartdns.@server[19].blacklist_ip='0'
  uci commit smartdns
  /etc/init.d/smartdns restart
fi
uci commit
sleep 1s
need_restart=0
if [ "$(opkg list-installed 2>/dev/null | grep -c "^luci-app-tailscale")" -ne '0' ] && [ "$(cat /usr/share/luci/menu.d/luci-app-tailscale.json | grep -c "services")" -ne '0' ]; then
  sed -i 's/services/vpn/g' /usr/share/luci/menu.d/luci-app-tailscale.json && rm -rf luci-indexcache.*.json
  need_restart=1
fi
if [ "$(opkg list-installed 2>/dev/null | grep -c "^luci-app-ttyd")" -ne '0' ] && [ "$(cat /usr/share/luci/menu.d/luci-app-ttyd.json | grep -c "services")" -ne '0' ]; then
  sed -i 's/services/system/g' /usr/share/luci/menu.d/luci-app-ttyd.json && rm -rf luci-indexcache.*.json
  need_restart=1
fi
if [ "$need_restart" -eq '1' ]; then
  /etc/init.d/rpcd restart
fi
