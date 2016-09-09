#!/bin/bash
# Spin up script
DIR="$(pwd)"

## Update and install core packages
apt-get update
apt-get dist-upgrade -y
apt-get install -y software-properties-common git curl wget gpg

## Rng
if [ -b /dev/hwrng ]; then
    apt-get install -y rng-tools
    cp -vf $DIR/etc/default/rng-tools /etc/default/rng-tools
    systemctl enable rng-tools
    systemctl restart rng-tools
else
    apt-get install -y haveged
    cp -vf $DIR/etc/default/haveged /etc/default/haveged
fi

## Setup dnsmasq
apt-get install -y dnsmasq
cp -vf $DIR/etc/dnsmasq.conf /etc/dnsmasq.conf
cp -vf $DIR/etc/default/dnsmasq /etc/default/dnsmasq
systemctl enable dnsmasq
systemctl restart dnsmasq

## Setup APT
cp -vf $DIR/etc/apt/sources.list /etc/apt/sources.list
apt-get update

## Setup Tor
cp -vf $DIR/etc/apt/sources.list.d/xenial-deb.torproject.org.list /etc/apt/sources.list.d/xenial-deb.torproject.org.list
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
apt-get update
apt-get install -y deb.torproject.org-keyring tor
cp -vf $DIR/etc/tor/torrc /etc/tor/torrc

## Setup iptables
apt-get install -y iptables iptables-persistent
cp -vf $DIR/etc/iptables/rules.v4 /etc/iptables/rules.v4
cp -vf $DIR/etc/iptables/rules.v6 /etc/iptables/rules.v6
iptables-restore < /etc/iptables/rules.v4
ip6tables-restore < /etc/iptables/rules.v6

## Setup BASH Env
cp -vf $DIR/home/bash_aliases ~/.bash_aliases
sed -s 's/#force_color_prompt/force_color_prompt/g' -i ~/.bashrc  # works

## Setup LXC
apt-get install -y software-properties-common
add-apt-repository -y --enable-source ppa:ubuntu-lxc/stable --keyserver="hkp://keyserver.ubuntu.com:80/"
apt update
apt-get install -y lxc lxc1 lxc-dev lxc-templates lxctl lxcfs lxc-tests
