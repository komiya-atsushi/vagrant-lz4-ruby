#!/bin/bash -e

GITHUB_REPO_URL=$1

curl -sSL https://get.rvm.io | bash -s stable

source /home/vagrant/.bash_profile

cat >>/home/vagrant/.tmux.conf << EOS
set-option -g prefix C-t
unbind-key C-b
bind-key C-t send-prefix
EOS

cd /home/vagrant
git clone ${GITHUB_REPO_URL}
cd lz4-ruby

function setup_ruby_env() {
    VER=$1

    rvm install ${VER}
    rvm use ${VER} --default
    rvm gemset create lz4-ruby
    rvm gemset use lz4-ruby
    gem install bundler
    bundle install
}

VER_MRI_18=`rvm list known_strings | grep 1.8.7-p | sed -e s/ruby-//`
VER_MRI_19=`rvm list known_strings | grep 1.9.3-p | sed -e s/ruby-//`
VER_JRUBY=jruby

setup_ruby_env ${VER_MRI_18}
bundle exec rake-compiler cross-ruby VERSION=${VER_MRI_18} EXTS=--without-extensions

setup_ruby_env ${VER_MRI_19}
bundle exec rake-compiler cross-ruby VERSION=${VER_MRI_19} EXTS=--without-extensions

setup_ruby_env ${VER_JRUBY}
