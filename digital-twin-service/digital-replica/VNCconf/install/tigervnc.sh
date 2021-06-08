#!/usr/bin/env bash
set -e

echo "Install TigerVNC server"
wget -qO- https://deac-ams.dl.sourceforge.net/project/tigervnc/stable/1.8.0/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
