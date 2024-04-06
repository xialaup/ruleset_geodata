#!/bin/bash

# 自动转换脚本

# 查找需要转换成 geodata 的规则名称
list=($(ls ./tmp/mydata/))
mkdir -p ./community/mydata/

# 包含广告拦截和流媒体的 geosite-all.dat
if ls ./tmp/mydata/ | grep -q 'ads' && ls ./tmp/mydata/ | grep -q 'netflix'; then
  for ((i = 0; i < ${#list[@]}; i++)); do
    curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" | sed 's/^DOMAIN,/full:/' | sed 's/^DOMAIN-SUFFIX,//' | sed 's/^DOMAIN-KEYWORD,/keyword:/' > "./community/mydata/${list[i]}"
  done
  go run ./ --datapath=./community/mydata/ --outputname geosite-all.dat
fi

# 不包含广告拦截，但包含流媒体的 geosite-all-lite.dat
if ls ./tmp/mydata/ | grep -qv 'ads' && ls ./tmp/mydata/ | grep -q 'netflix'; then
  for ((i = 0; i < ${#list[@]}; i++)); do
    curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" | sed 's/^DOMAIN,/full:/' | sed 's/^DOMAIN-SUFFIX,//' | sed 's/^DOMAIN-KEYWORD,/keyword:/' > "./community/mydata/${list[i]}"
  done
  go run ./ --datapath=./community/mydata/ --outputname geosite-all-lite.dat
fi

# 包含广告拦截，但不包含流媒体的 geosite.dat
if ls ./tmp/mydata/ | grep -q 'ads' && ls ./tmp/mydata/ | grep -qv 'netflix'; then
  for ((i = 0; i < ${#list[@]}; i++)); do
    curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" | sed 's/^DOMAIN,/full:/' | sed 's/^DOMAIN-SUFFIX,//' | sed 's/^DOMAIN-KEYWORD,/keyword:/' > "./community/mydata/${list[i]}"
  done
  go run ./ --datapath=./community/mydata/ --outputname geosite.dat
fi

# 既不包含广告拦截，也不包含流媒体的 geosite-lite.dat
if ls ./tmp/mydata/ | grep -qv 'ads' && ls ./tmp/mydata/ | grep -qv 'netflix'; then
  for ((i = 0; i < ${#list[@]}; i++)); do
    curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" | sed 's/^DOMAIN,/full:/' | sed 's/^DOMAIN-SUFFIX,//' | sed 's/^DOMAIN-KEYWORD,/keyword:/' > "./community/mydata/${list[i]}"
  done
  go run ./ --datapath=./community/mydata/ --outputname geosite-lite.dat
fi

# 查找需要转换成 ruleset 的规则名称
list=($(ls ./tmp/ruleset/))
for ((i = 0; i < ${#list[@]}; i++)); do
  mkdir -p "./rules/${list[i]}/"

  # 转换成 clash rule-set yaml 格式文件
  echo 'payload:' > "./clash-ruleset/${list[i]}.yaml"
  curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" | grep -v 'DOMAIN-KEYWORD,' | sed "s/^DOMAIN,/  - '/" | sed "s/^DOMAIN-SUFFIX,/  - '+\./" | sed "s/$/'/" > "./clash-ruleset/${list[i]}.yaml"
  
  # 转换成 clash rule-set text 格式文件
  curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" | grep -v 'DOMAIN-KEYWORD,' | sed 's/^DOMAIN,//' | sed 's/^DOMAIN-SUFFIX,/+\./' > "./clash-ruleset/${list[i]}.list"
  
  # 准备转换 sing-box rule_set 文件
  curl -sSL "https://raw.githubusercontent.com/DustinWin/domain-list-custom/domains/${list[i]}.list" > "./rules/${list[i]}/${list[i]}.yaml"
done
