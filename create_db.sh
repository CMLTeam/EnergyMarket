#!/usr/bin/env bash

echo "
create database energymarket CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
grant all privileges on energymarket.* to 'energymarket'@'%' identified by 'energymarket';
flush privileges;
" | mysql -uroot -p
