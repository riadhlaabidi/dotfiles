cd /tmp 

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.zip
unzip DejaVuSansMono.zip -d DejaVuSansMono
mv DejaVuSansMono /usr/local/share/fonts
rm -rf DejaVuSansMono.zip

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaMono
mv CascadiaMono /usr/local/share/fonts
rm -rf CascadiaMono.zip

fc-cache

cd -
