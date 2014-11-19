#!/bin/bash

# Script to set up dependencies for Django on Vagrant.

PGSQL_VERSION=9.1

# Need to fix locale so that Postgres creates databases in UTF-8
cp -p /vagrant_data/etc-bash.bashrc /etc/bash.bashrc
locale-gen en_GB.UTF-8
dpkg-reconfigure locales

export LANGUAGE=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# Install essential packages from Apt
apt-get update -y
# Python dev packages
apt-get install -y build-essential python python-dev python-setuptools python-pip
# Dependencies for image processing with PIL
apt-get install -y libjpeg62-dev zlib1g-dev libfreetype6-dev liblcms1-dev
# Git (we'd rather avoid people keeping credentials for git commits in the repo, but sometimes we need it for pip requirements that aren't in PyPI)
apt-get install -y git

# Postgresql
if ! command -v psql; then
    apt-get install -y postgresql-$PGSQL_VERSION libpq-dev
    cp /vagrant_data/pg_hba.conf /etc/postgresql/$PGSQL_VERSION/main/
    /etc/init.d/postgresql reload
fi

#PostGIS, according to http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS20Ubuntu1204src
apt-get install -y build-essential postgresql-server-dev-$PGSQL_VERSION libxml2-dev libproj-dev libjson0-dev xsltproc docbook-xsl docbook-mathml
apt-get install -y libgdal1-dev
#GEOS
wget http://download.osgeo.org/geos/geos-3.3.9.tar.bz2
tar xfj geos-3.3.9.tar.bz2
cd geos-3.3.9
./configure
make
make install
cd ..

wget http://download.osgeo.org/postgis/source/postgis-2.0.4.tar.gz
tar xfz postgis-2.0.4.tar.gz
cd postgis-2.0.4
./configure
make
make install
ldconfig
make comments-install

ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/shp2pgsql
ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/pgsql2shp
ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/raster2pgsql

#GDAL bin
apt-get install -y gdal-bin

#Vim
apt-get install -y vim
cp /vagrant_data/vimrc /home/vagrant/.vimrc

#unzip
apt-get install -y unzip

# virtualenv global setup
if ! command -v pip; then
    easy_install -U pip
fi
if [[ ! -f /usr/local/bin/virtualenv ]]; then
    pip install virtualenv virtualenvwrapper stevedore virtualenv-clone
fi

# bash environment global setup
cp -p /vagrant_data/bashrc /home/vagrant/.bashrc


echo '|||||||| --  MFR customizations  -- |||||||'
echo '===== Installing other prereqs'
# Other pre-reqs for project or bootstrapping
apt-get install libxml2-dev libxslt1-dev curl


echo '===== Upgrading to Ruby 2.0'
# based on http://stackoverflow.com/questions/16222738/how-do-i-install-ruby-2-0-0-correctly-on-ubuntu-12-04
CUR_DIR=`pwd`
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p481.tar.gz
tar -xvzf ruby-2.0.0-p481.tar.gz
cd ruby-2.0.0-p481/
./configure --prefix=/usr/local
make
make install
cd $CUR_DIR


echo '===== Installing bundler gem'
gem update --system
gem install bundler


echo '===== Creating PostgreSQL databases and users'
su postgres << EOF
    psql -c "CREATE USER vagrant CREATEDB CREATEUSER;"
EOF

createdb -U vagrant mfr
echo 'CREATE EXTENSION postgis' | psql -U vagrant mfr

# TODO install bundles

# Install node/npm




