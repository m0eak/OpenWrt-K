if [ "$( opkg list-installed 2>/dev/null| grep -c "^mosdns")" -ne '0' ];then
  uci set mosdns.config.enabled='1'
  uci set mosdns.config.redirect='1'
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
  uci set openclash.config.en_mode='redir-host-mix'
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
  uci set openclash.config.ipv6_mode='0'
  uci set openclash.config.enable_v6_udp_proxy='1'
  uci set openclash.config.china_ip6_route='1'
  uci add openclash rule_provider_config
  uci set openclash.@rule_provider_config[-1].enabled='1'
  uci set openclash.@rule_provider_config[-1].interval='86400'
  uci set openclash.@rule_provider_config[-1].config='all'
  uci set openclash.@rule_provider_config[-1].group='DIRECT'
  uci set openclash.@rule_provider_config[-1].position='0'
  uci add_list openclash.@rule_provider_config[-1].rule_name='直连规则(by 沉默の金)'
  uci add_list openclash.@rule_provider_config[-1].rule_name='国内IP白名单'
  uci add_list openclash.@rule_provider_config[-1].rule_name='国内域名白名单'
  uci commit openclash
fi
