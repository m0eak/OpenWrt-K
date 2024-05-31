#!/bin/bash
config=$1
openwrt_tag_branch=$(sed -n '/openwrt_tag\/branch/p' $GITHUB_WORKSPACE/config/"$config"/OpenWrt-K/compile.config | sed -e 's/.*=//')
openwrt_tag_branch_v=$(sed -n '/openwrt_tag\/branch/p' $GITHUB_WORKSPACE/config/"$config"/OpenWrt-K/compile.config | sed -e 's/.*=v//')
sed -i 's/^  DEPENDS:= +kmod-crypto-manager +kmod-crypto-pcbc +kmod-crypto-fcrypt$/  DEPENDS:= +kmod-crypto-manager +kmod-crypto-pcbc +kmod-crypto-fcrypt +kmod-udptunnel4 +kmod-udptunnel6/' package/kernel/linux/modules/netsupport.mk #https://github.com/openwrt/openwrt/commit/ecc53240945c95bc77663b79ccae6e2bd046c9c8
sed -i 's/^	dnsmasq \\$/	dnsmasq-full \\/g' ./include/target.mk
sed -i 's/^	b43-fwsquash.py "$(CONFIG_B43_FW_SQUASH_PHYTYPES)" "$(CONFIG_B43_FW_SQUASH_COREREVS)"/	$(TOPDIR)\/tools\/b43-tools\/files\/b43-fwsquash.py "$(CONFIG_B43_FW_SQUASH_PHYTYPES)" "$(CONFIG_B43_FW_SQUASH_COREREVS)"/' ./package/kernel/mac80211/broadcom.mk
# Tailscale
[ -e "./feeds/packages/net/tailscale/Makefile" ] && sed -i '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' feeds/packages/net/tailscale/Makefile
[ -e "./package/extpackages/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale.json" ] && sed -i 's/services/vpn/g' package/extpackages/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale.json && echo "Tailscale分组修改完成"
# 固定Vermagic
if grep -q "x86_64" $GITHUB_WORKSPACE/config/"$config"/target.config; then
  echo "固定Vermagic"
  curl -s https://downloads.openwrt.org/releases/$openwrt_tag_branch_v/targets/x86/64/openwrt-$openwrt_tag_branch_v-x86-64.manifest | grep kernel | awk '{print $3}' | awk -F- '{print $3}' > vermagic
  echo "当前Vermagic:"
  cat vermagic
  sed -i '121s|^|# |' ./include/kernel-defaults.mk
  sed -i $'121a\\\tcp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic\\' ./include/kernel-defaults.mk
  echo "固定Vermagic完成"
fi
if grep -q "mediatek_filogic" $GITHUB_WORKSPACE/config/"$config"/target.config; then
  echo "固定Vermagic"
  curl -s https://downloads.openwrt.org/releases/$openwrt_tag_branch_v/targets/mediatek/filogic/openwrt-$openwrt_tag_branch_v-mediatek-filogic.manifest | grep kernel | awk '{print $3}' | awk -F- '{print $3}' > vermagic
  echo "当前Vermagic:"
  cat vermagic
  sed -i '121s|^|# |' ./include/kernel-defaults.mk
  sed -i $'121a\\\tcp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic\\' ./include/kernel-defaults.mk
  echo "固定Vermagic完成"
fi
# gl-mt3000打风扇Patch
if grep -q "gl-mt3000" $GITHUB_WORKSPACE/config/"$config"/target.config; then
  wget https://raw.githubusercontent.com/m0eak/openwrt_patch/main/mt3000/980-dts-mt7921-add-cooling-levels.patch 
  mv 980-dts-mt7921-add-cooling-levels.patch ./target/linux/mediatek/patches-5.15/980-dts-mt7921-add-cooling-levels.patch 
  echo "Patch Done"
fi
# https://github.com/openwrt/packages/pull/22251
if [[ "$openwrt_tag_branch" == "v23.05.0-rc4" ]] ; then
  if grep -q "^define Package/prometheus-node-exporter-lua-bmx6$" "feeds/packages/utils/prometheus-node-exporter-lua/Makefile"; then
    echo "修复https://github.com/openwrt/packages/pull/22251"
    curl -s -L --retry 6 https://github.com/openwrt/packages/commit/361b360d2bbf7abe93241f6eaa12320d8d83475a.patch  | patch -p1 -d feeds/packages 2>/dev/null
  fi
fi
if [[ "$openwrt_tag_branch" == "v23.05.2" ]] ; then
  if ! grep -q "^  CONFLICTS:=iperf3$" "feeds/packages/net/iperf3/Makefile"; then
    echo "修复iperf3冲突"
    curl -s -L --retry 6 https://github.com/openwrt/packages/commit/cea45c75c0153a190ee41dedaf6526ae08e33928.patch  | patch -p1 -d feeds/packages 2>/dev/null
  fi
fi
if [[ "$openwrt_tag_branch" == "v23.05.3" ]] || [[ "$openwrt_tag_branch" == "openwrt-23.05" ]] ; then
  echo "修复libpfring"
  curl -s -L --retry 6 https://github.com/openwrt/packages/commit/534bd518f3fff6c31656a1edcd7e10922f3e06e5.patch  | patch -p1 -d feeds/packages 2>/dev/null
  curl -s -L --retry 6 https://github.com/openwrt/packages/commit/c3a50a9fac8f9d8665f8b012abd85bb9e461e865.patch  | patch -p1 -d feeds/packages 2>/dev/null
fi
