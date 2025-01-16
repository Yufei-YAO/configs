# configs
my configs in various tools


===============================================
tmux config

.tmux.conf  ------>  ~/.tmux.conf

===============================================
zsh

sudo apt install zsh

chsh -s $(which zsh)  // change defalut shell  ehco $SHELL to see

install oh-my-zsh in web


===============================================




NVIM 配置
======install new neovim====
sudo wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
	sudo tar xzvf nvim-linux64.tar.gz
	sudo mv nvim-linux64 /usr/local/nvim
sudo ln -s /usr/local/nvim/bin/nvim /usr/bin/nvim

======install new nodejs====
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

======install yarn==========

======lsp ================
coc.nvim for other

:CocInstall pyright  

Ccls for c++
sudo apt install ccls

=====Treesitter===========
:TSinstall cpp

=======Telescope===========
Telescope need install ripgrep


========DIFFVIEW===========
Need new git 




========nedd==============
CodeNewRoman Nerd Font
Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher
sudo unzip CodeNewMan.zip  -d /usr/share/fonts/opentype/CodeNewMan
fc-cache -f -v
fc-list | grep "CodeNewMan"

windows直接安装并在powershell 设置->powershell->外观->字体

Dap
LunarVim DAP-{CPP,Python,Go,Rust} Debug配置🤭 - 知乎
