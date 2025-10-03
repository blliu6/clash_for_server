#!/bin/bash

# 重命名文件夹
cd ..
mv $(basename $(pwd)) ~/.clash

# Clash 配置内容
CLASH_CONFIG='# clash config 
clash_on() { 
    # 1. 在后台启动 Clash 进程 
    ~/.clash/clash -d ~/.clash/ & 
    
    # 2. 设置代理环境变量 
    export http_proxy=http://127.0.0.1:52000 
    export https_proxy=http://127.0.0.1:52000 
    export no_proxy=127.0.0.1,localhost 
    
    # 3. 打印统一的成功信息 
    echo -e "\033[32m[✓] Clash 已启动，系统代理已开启\033[0m" 
} 

clash_off() { 
    # 1. 终止所有 Clash 进程 
    pkill clash 
    
    # 2. 取消设置代理环境变量 
    unset http_proxy 
    unset https_proxy 
    unset no_proxy 
    
    # 3. 打印统一的关闭信息 
    echo -e "\033[31m[×] Clash 已停止，系统代理已关闭\033[0m" 
} 
# clash config'

# 判断shell类型并写入配置
if [ -n "$ZSH_VERSION" ]; then
    echo "$CLASH_CONFIG" >> ~/.zshrc
    source ~/.zshrc
else
    echo "$CLASH_CONFIG" >> ~/.bashrc
    source ~/.bashrc
fi

echo "安装完成"

