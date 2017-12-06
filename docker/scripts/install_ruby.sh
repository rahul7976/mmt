#!/bin/sh
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

rbenv install -v 2.2.2
rbenv global 2.2.2
