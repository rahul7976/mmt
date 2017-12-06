#!/bin/bash
gem install bundler
rbenv rehash
git clone https://github.com/nasa/mmt
cd ~/mmt
bundle install
echo 'export CMR_URS_PASSWORD=mock-urs-password' >> ~/.bashrc
source ~/.bashrc
