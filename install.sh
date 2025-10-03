#!/bin/bash

# 1. 设置默认端口
DEFAULT_PORT="7890"

# 2. 提示用户输入，并将输入内容存入变量 USER_PORT
read -p "请输入代理端口号 (直接回车将使用默认端口 ${DEFAULT_PORT}): " USER_PORT

# 3. 判断用户是否输入了内容。如果没输入，则使用默认端口；否则使用用户输入的端口。
#    ${VARIABLE:-default_value} 是一个简便写法
PORT=${USER_PORT:-$DEFAULT_PORT}

echo "代理端口将被设置为: $PORT"
echo "----------------------------------------"

# 重命名文件夹
cd ..
mv clash_for_server ~/.clash

# Clash 配置内容
read -r -d '' CLASH_CONFIG <<EOF
# clash config
clash_on() {
    # 1. 在后台启动 Clash 进程
    ~/.clash/clash -d ~/.clash/ &

    # 2. 设置代理环境变量 (使用您选择的端口)
    export http_proxy=http://127.0.0.1:$PORT
    export https_proxy=http://127.0.0.1:$PORT
    export no_proxy=127.0.0.1,localhost

    # 3. 打印统一的成功信息
    echo -e "\033[32m[✓] Clash 已启动，系统代理已开启 (端口: $PORT)\033[0m"
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
# clash config
EOF

# 判断shell类型并写入配置
if [ -n "$ZSH_VERSION" ]; then
    echo "$CLASH_CONFIG" >> ~/.zshrc
    source ~/.zshrc
else
    echo "$CLASH_CONFIG" >> ~/.bashrc
    source ~/.bashrc
fi

echo "安装完成"

