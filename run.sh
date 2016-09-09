#!/bin/bash
# Spin up script
DIR="$(pwd)"

## Update and install core packages
apt-get update
apt-get dist-upgrade -y
apt-get install -y software-properties-common git curl wget

## Install dnsmasq
apt-get install -y dnsmasq
cp -vf $DIR/etc/dnsmasq.conf /etc/dnsmasq.conf
cp -vf $DIR/etc/default/dnsmasq /etc/default/dnsmasq
systemctl enable dnsmasq
systemctl restart dnsmasq

## Setup APT
cp -vf $DIR/etc/apt/sources.list /etc/apt/sources.list
apt-get update
