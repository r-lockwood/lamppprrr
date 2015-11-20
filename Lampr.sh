#!/bin/bash
echo /##########################
echo /### Setting Up System /###
echo /##########################
cd ~
sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap
echo /################################
echo /### Installing Dependencies /###
echo /################################
sudo apt-get -y install gcc build-essential make curl zlib1g zlib1g-dev zlibc libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev libxml2-dev libapr1-dev libxslt1-dev python-software-properties libffi-dev autoconf libc6-dev && sudo apt-get -y install -f
echo /##########################
echo /### Installing Apache /###
echo /##########################
sudo apt-get -y update && sudo -y apt-get upgrade
sudo apt-get -y install apache2 && sudo apt-get -y install -f
echo /#########################
echo /### Installing MySQL /###
echo /#########################
sudo apt-get -y update && sudo -y apt-get upgrade
sudo apt-get -y install mysql-server && sudo apt-get -y install -f
echo /########################
echo /### Installing PHP5 /###
echo /########################
sudo apt-get -y update && sudo -y apt-get upgrade
sudo apt-get -y install php5 libapache2-mod-php5 php5-cli php5-cgi php5-mysql && sudo apt-get -y install –f
echo /##############################
echo /### Installing PHPMyAdmin /###
echo /##############################
sudo apt-get -y update && sudo -y apt-get upgrade
sudo apt-get -y install php5 libapache2-mod-php5 php5-cli php5-cgi php5-mysql && sudo apt-get -y install –f
echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo /###############################
echo /### Installing Ruby Source /###
echo /###############################
sudo apt-get -y update && sudo apt-get -y upgrade
cd ~
wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz
tar xvfz ruby-2.2.3.tar.gz
cd ruby-2.2.3/
./configure --enable-pthread --prefix=/usr/local
make && sudo make install
echo /####################################
echo /### Making Ruby Support OpenSSL /###
echo /####################################
cd ext/openssl/
ruby extconf.rb
rm Makefile
wget https://raw.githubusercontent.com/r-lockwood/lamppprrr/master/Makefile
make  && sudo make install
echo /#####################################
echo /### Installing bundler & node.js /###
echo /#####################################
cd ../..
sudo gem install bundler
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install nodejs
echo /#########################
echo /### Installing Rails /###
echo /#########################
sudo gem install rails
echo /#############################
echo /### Installing Passenger /###
echo /#############################
sudo gem install passenger
echo "LoadModule passenger_module /usr/local/lib/ruby/gems/2.2.0/gems/passenger-5.0.21/buildout/apache2/mod_passenger.so" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo "<IfModule mod_passenger.c>" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo "PassengerRoot /usr/local/lib/ruby/gems/2.2.0/gems/passenger-5.0.21" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo "PassengerDefaultRuby /usr/local/bin/ruby" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo "</IfModule>" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
sudo service apache2 restart
sudo passenger-install-apache2-module
echo /#####################################
echo /### Configuring Passenger/Apache /###
echo /#####################################
sudo touch /etc/apache2/mods-available/passenger.load
echo "LoadModule passenger_module /usr/local/lib/ruby/gems/2.2.0/gems/passenger-5.0.21/ext/ apache2/mod_passenger.so" | sudo tee -a /etc/apache2/mods-available/passenger.load > /dev/null
sudo touch /etc/apache2/mods-available/passenger.conf
echo "PassengerRoot /usr/local/lib/ruby/gems/2.2.0/gems/passenger-5.0.21" | sudo tee -a /etc/apache2/mods-available/passenger.conf > /dev/null
echo "PassengerRuby /usr/local/bin/ruby" | sudo tee -a /etc/apache2/mods-available/passenger.conf > /dev/null
echo "PassengerDefaultUser www-data" | sudo tee -a /etc/apache2/mods-available/passenger.conf > /dev/null
a2enmod passenger
service apache2 restart
