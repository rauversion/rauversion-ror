set -x


# Add NodeJS to sources list
# curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -
curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
apt-get install -y nodejs

#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list


#apt update
#apt -y install yarn

npm install -g yarn
