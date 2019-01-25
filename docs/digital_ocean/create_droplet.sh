# use rails user
sudo -i -u rails
git clone https://github.com/AndersonCamargo20/autoatendimento_DCE_SUPRIMAQ

# back to root user again
exit

vi /etc/systemd/system/rails.service
systemctl daemon-reload
systemctl restart rails

vi /etc/nginx/sites-available/rails
/etc/init.d/nginx restart

# use rails user
sudo -i -u rails
echo "export RAILS_ENV='production'" >> ~/.bash_profile
echo "export RAKE_ENV='production'" >> ~/.bash_profile
echo "export RAILS_MASTER_KEY='AYRNVySyjpMyxGMRBwYCQrHaSHAcvEWjuWfSjvNGtKxk7DCJKE9PHZ6T8MCjDTxdYQvgCwpXJ6GJf2xcQUTnHK28hFnK3T5gyp5jhnDvGzXb38V6cCpGzG4KqbVdd8jP'" >> ~/.bash_profile
echo "export SECRET_KEY_BASE='AYRNVySyjpMyxGMRBwYCQrHaSHAcvEWjuWfSjvNGtKxk7DCJKE9PHZ6T8MCjDTxdYQvgCwpXJ6GJf2xcQUTnHK28hFnK3T5gyp5jhnDvGzXb38V6cCpGzG4KqbVdd8jP'" >> ~/.bash_profile

source ~/.bash_profile

# back to root user again
exit

# install Yarn - https://yarnpkg.com/lang/en/docs/install/#debian-stable
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

# create swapfile
sudo fallocate -l 4G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# install version that work with ruby 2.3.3
apt-get install libssl1.0-dev

# use rails user
sudo -i -u rails

rvm install "ruby-2.3.3"
rvm --default use "ruby-2.3.3"

cd autoatendimento_DCE_SUPRIMAQ
bundle install
yarn install

EDITOR=vi rails credentials:edit

rake db:create
rake db:migrate
rake assets:precompile

# back to root user again
exit
service rails restart