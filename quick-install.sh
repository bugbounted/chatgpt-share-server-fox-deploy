#!/bin/bash
set -e

## 克隆仓库到本地
echo "clone repository..."
git clone --depth=1 https://github.com/xiaomifengd/chatgpt-share-server-fox-deploy.git chatgpt-share-server-fox


## 进入目录
cd chatgpt-share-server-fox

chmod +x fox.sh
./fox.sh
