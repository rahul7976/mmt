#!/bin/bash
source /etc/profile.d/rvm.sh
cd /home/mmt
git clone https://github.com/nasa/mmt
cd mmt
gem install bundler
bundle install
echo 'export CMR_URS_PASSWORD=mock-urs-password' >> ~/.bashrc
source ~/.bashrc
