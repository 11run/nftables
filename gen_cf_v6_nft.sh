#!/bin/bash

# CloudflareのIPv6リストを取得
CF_IPv6_LIST_URL="https://www.cloudflare.com/ips-v6/"
CF_IPv6_LIST=$(curl -s ${CF_IPv6_LIST_URL})

# nftablesの設定を直接追加するコマンドを出力する関数
generate_nft_command() {
    local ip_address=$1
    echo "add rule ip6 filter INPUT ip6 saddr ${ip_address} tcp dport {80, 443} accept"
}

# CloudflareのIPv6アドレス範囲を許可するルールを生成
while IFS= read -r line; do
    generate_nft_command "${line}"
done <<< "${CF_IPv6_LIST}"

# その他のトラフィックをドロップするルールを追加
echo "add rule ip6 filter INPUT tcp dport {80, 443} drop"