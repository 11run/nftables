#!/bin/bash

# CloudflareのIPv4リストを取得
CF_IPv4_LIST_URL="https://www.cloudflare.com/ips-v4/"
CF_IPv4_LIST=$(curl -s ${CF_IPv4_LIST_URL})

# nftablesの設定を直接追加するコマンドを出力する関数
generate_nft_command() {
    local ip_address=$1
    echo "add rule ip filter INPUT ip saddr ${ip_address} tcp dport {80, 443} accept"
}

# CloudflareのIPv4アドレス範囲を許可するルールを生成
while IFS= read -r line; do
    generate_nft_command "${line}"
done <<< "${CF_IPv4_LIST}"

# その他のトラフィックをドロップするルールを追加
echo "add rule ip filter INPUT tcp dport {80, 443} drop"