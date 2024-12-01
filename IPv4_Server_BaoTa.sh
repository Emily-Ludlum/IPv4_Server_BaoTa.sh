#!/bin/bash

# 第一步：【查询端口占用情况】
echo "查询80端口是否被占用..."
apt install -y net-tools # 安装 net-tools 用于查询端口
netstat -anp | grep 80 # 查询80端口占用情况

# 第二步：【设置防火墙规则】
echo "***执行命令（关闭防火墙）开放所有端口，用于测试环境..."
apt-get install -y iptables # 安装iptables
iptables -P INPUT ACCEPT # 允许所有输入流量
iptables -P FORWARD ACCEPT # 允许所有转发流量
iptables -P OUTPUT ACCEPT # 允许所有输出流量
iptables -F # 清空现有防火墙规则
iptables-save # 保存防火墙规则

# 第三步：【更新系统，安装依赖等常用工具】
echo "***更新系统并安装必要的工具..."
apt update -y
apt install -y wget curl git vim unzip sudo

# 第四步：【安装“中文版”宝塔 + 降级到7.7 + 解锁电话绑定限制】
echo "***安装宝塔面板..."
wget -O install.sh https://download.bt.cn/install/install_lts.sh && sudo bash install.sh -y

echo "***下载宝塔7.7.0..."
wget https://raw.githubusercontent.com/Emily-Ludlum/LinuxPanel-7.7.0.zip/main/LinuxPanel-7.7.0.zip

echo "***执行降级到宝塔7.7.0..."
cd /root
unzip LinuxPanel-7.7.0.zip
cd /root/panel
bash update.sh
rm -f /www/server/panel/data/bind.pl # 解锁电话绑定限制
cd
rm -f /root/LinuxPanel-7.7.0.zip
rm -rf /root/Panel

# 第五步：【配置宝塔面板】
echo "***修改宝塔面板配置..."
sed -i 's/^panelPort=.*/panelPort=8880/' /www/server/panel/data/port.pl
systemctl restart bt

echo "***修改宝塔面板用户名..."
btctl user BaoTa

echo "***修改宝塔面板密码..."
btctl passwd Abcd@1234

echo "***取消登录地址后缀限制..."
sed -i 's/^\(panelPath\)=.*$/\1=/' /www/server/panel/data/config.json
systemctl restart bt

# 第六步：【宝塔面板首次登录提示】
echo "***宝塔面板首次登录信息..."
echo "宝塔面板登录地址：http://baota.isoho.tk:8880/"
echo "用户名：BaoTa"
echo "密码：Abcd@1234"

echo "***宝塔面板配置完成，所有服务已启动！"
echo "安装成功!"
