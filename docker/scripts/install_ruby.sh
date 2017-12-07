curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm requirements
rvm reload
rvm install 2.2.2
rvm use 2.2.2 --default
rvm rubygems current
gem install rails
gem install bundler
