#!/bin/bash
cd /home/mmt/mmt
cp config/database.yml.example config/database.yml
rake db:create
rake db:migrate
