#!/bin/sh
cd ~/mmt
cp config/database.yml.example config/database.yml
rake db:create
rake db:migrate
