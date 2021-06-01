#!/bin/sh
# create self-signed server certificate:
# 创建自签名服务器证书
read -p "Enter your domain [www.example.com]: " DOMAIN

echo "Create server key..."
openssl genrsa -des3 -out $DOMAIN.key 1024
echo ----------------------------------------------
echo "Create server certificate signing request..."
#SUBJECT的说明
# C: Country Name (2 letter code) [XX]:CN
# ST: State or Province Name (full name) []:GuangDong
# L: Locality Name (eg, city) [Default City]:guangzhou
# O: Organization Name (eg, company) [Default Company Ltd]: 
# OU: Organizational Unit Name (eg, section) []:IT
# CN: Common Name (eg, your name or your server's hostname) []: 普通名称（例如，您的姓名或您的服务器的主机名）,随便写. 指定CA认证中心服务器的名字
SUBJECT="/C=CN/ST=GuangDong/L=GuangZhou/O=IT/OU=IT/CN=$DOMAIN"
openssl req -new -subj $SUBJECT -key $DOMAIN.key -out $DOMAIN.csr
echo ----------------------------------------------
echo "Remove password..."
mv $DOMAIN.key $DOMAIN.origin.key
openssl rsa -in $DOMAIN.origin.key -out $DOMAIN.key
echo ----------------------------------------------
echo "Sign SSL certificate..."
openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
echo ----------------------------------------------
echo "自签名证书已完成"
echo "如果nginx服务想使用SSL,你可以"
echo "TODO:"
echo "Copy $DOMAIN.crt to /etc/nginx/ssl/$DOMAIN.crt"
echo "Copy $DOMAIN.key to /etc/nginx/ssl/$DOMAIN.key"
echo "Add configuration in nginx:"
echo "server {"
echo "    ..."
echo "    listen 443 ssl;"
echo "    ssl_certificate     /etc/nginx/ssl/$DOMAIN.crt;"
echo "    ssl_certificate_key /etc/nginx/ssl/$DOMAIN.key;"
echo "}"