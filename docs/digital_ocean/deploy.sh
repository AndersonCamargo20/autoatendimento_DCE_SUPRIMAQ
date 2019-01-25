# to deploy
sudo -i -u rails
cd autoatendimento_DCE_SUPRIMAQ
git pull origin master
rake assets:precompile
# back to root user again
exit
service rails restart