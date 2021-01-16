#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath $0))
ERROR_EXIT=1

function arch_prepare {
  # Install curl for file downloading
  pacman -Q curl || sudo pacman -S curl

  # Install tmux
  pacman -Q tmux || sudo pacman -S tmux
  # Install tmuxinator
  #sudo pacman -S ruby-native-package-installer
  #gem install tmuxinator
  # Install tmuxp
  pip install tmuxp --user

  # Install sytax checker for syntastic
  pacman -Q flake8 || sudo pacman -S flake8
  pacman -Q shellcheck ||sudo pacman -S shellcheck

  # Install ripgrep for Rg command in vim-fzf
  pacman -Q ripgrep || sudo pacman -S ripgrep

  # Install ctags
  pacman -Q ctags || sudo pacman -S ctags

  # Install cscope
  pacman -Q cscope || sudo pacman -S cscope

  # Install zsh
  pacman -Q zsh || sudo pacman -S zsh
  
  # Install vim
  pacman -Q vim || sudo pacman -S vim

  # Install fasd
  pacman -Q fasd || sudo pacman -S fasd

  # Install make, gcc, etc. for YCM compilation
  pacman -Q cmake || sudo pacman -S cmake
  pacman -Q make || sudo pacman -S make
  pacman -Q gcc || sudo pacman -S gcc

  # Install external formatter for vim-autoformat
  # sudo pacman -S autopep8
  # sudo pacman -S python-black
  pip install --user black
  pacman -Q tidy || sudo pacman -S tidy
  pacman -Q npm || sudo pacman -S npm
  sudo npm install -g js-beautify
  sudo npm install -g remark-cli

  # Install shfmt
  # sudo pacman -S base-devel
  # sudo reboot
  # sudo pacman -S go
  # sudo pacman -S yaourt
  # yaourt -S shfmt
}

function ubuntu_prepare {
  # Install curl for file downloading
  sudo apt install curl

  # Add PPA for vim-nox and ripgrep
  sudo add-apt-repository ppa:pi-rho/dev
  sudo add-apt-repository ppa:x4121/ripgrep
  sudo apt update

  # Install tmux and tmux session manager(tmuxinator or tmuxp)
  sudo apt install -y tmux
  #sudo apt install -y tmuxinator
  sudo apt install -y tmuxp

  # Intall vim-nox which contains more features
  sudo apt install -y vim-nox

  # Install sytax checker for syntastic
  sudo apt install -y flake8 yamllint shellcheck

  # Install ripgrep for Rg command in vim-fzf
  sudo apt install ripgrep

  # Install ctags
  sudo apt install ctags

  # Install cscope
  sudo apt install cscope

  # Install packages for YCM language support compiling
  sudo apt-get install build-essential cmake
  sudo apt-get install python-dev python3-dev

  # Install zsh
  sudo apt install zsh
  
  # Install vim
  sudo apt intall vim
}

function init_tmux {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  cp $SCRIPT_DIR/conf/tmux.conf ~/.tmux.conf

  # echo "******************************************************************"
  # echo "* Please execute below steps after this script:                  *"
  # echo "* tmux                                                           *"
  # echo "* prefix +I(Ctrl + B, then Shift + i)                            *"
  # echo "******************************************************************"

  # Install plugins
  ~/.tmux/plugins/tpm/bin/install_plugins all

  # Clone tmuxinator repo for zsh completition
  #git clone https://github.com/tmuxinator/tmuxinator.git ~/.tmux/plugins/tmuxinator
  echo "# tmuxp completion" >> ~/.zshrc
  echo 'which tmuxp 2>&1 >/dev/null && eval "$(compdef _tmuxp_completion tmuxp)"' >> ~/.zshrc
}

function init_vim {
  # Refer to https://github.com/junegunn/vim-plug
  # curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  #  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  git clone https://github.com/junegunn/vim-plug.git /tmp/vim-plug
  mkdir -p ~/.vim/autoload
  cp /tmp/vim-plug/plug.vim ~/.vim/autoload/plug.vim
  cp $SCRIPT_DIR/conf/vimrc.vim-plug ~/.vimrc

  # Vista supports lsp which covers tags related showcase
  # # Install rst2ctags and markdown2ctags to support rst and md tags
  # sudo pacman -S rst2ctags || sudo apt install rst2ctags
  # pip install --user markdown2ctags
  # sudo cp ~/.local/bin/markdown2ctags /usr/local/bin/markdown2ctags.py
  #
  # # Add customized lanaguages support (such as Ansible ) to ctags in order to use tagbar
  # mkdir ~/.ctags.d
  # cp $SCRIPT_DIR/conf/ansible.ctags ~/.ctags.d

  # echo "******************************************************************"
  # echo "* Please execute below steps after this script:                  *"
  # echo "* Open vim                                                       *"
  # echo "* :PlugInstall                                                   *"
  # echo "******************************************************************"

  # Install plugins
  vim +PlugInstall +qa

  # Add customized key map documents
  mkdir ~/.vim/doc
  cp conf/ckeys.txt ~/.vim/doc
  vim +helptags ~/.vim/doc
}

function init_zprezto {
  # Clean potential conflicts
  rm -rf $HOME/.zprezto
  rm -rf $HOME/.zsh*
  rm -rf $HOME/.prezto*

  # Refer to https://github.com/sorin-ionescu/prezto on how to configure prezto
  # To upgrade zprezto:
  # - automatic update: zprezto-update
  # - manual update   : cd $ZPREZTODIR; git pull && git submodule update --init --recursive

  # Clone zprezto
  git clone --recursive https://github.com/sorin-ionescu/prezto.git $HOME/.zprezto

  for rcfile in $HOME/.zprezto/runcoms/*; do
    f_name=$(basename $rcfile)
    if [[ "$f_name" != "README.md" ]]; then
      ln -s -f $rcfile $HOME/.$f_name
    fi
  done

  cp $SCRIPT_DIR/conf/zpreztorc ~/.zpreztorc

  # # The highlight color won't work by default
  # echo 'export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"' >> ~/.zshrc
  #
  # # Set vim as the default editor instead of nano
  # echo 'export EDITOR="vim"' >> ~/.zshrc
  #
  # # Add cargo bin path where ripgrep will be installed
  # echo 'export PATH=$PATH:~/.cargo/bin' >> ~/.zshrc
  cp $SCRIPT_DIR/conf/zshrc ~/.zshrc

  # Append tmuxinator completion
  #echo 'source $HOME/.tmux/plugins/tmuxinator/completion/tmuxinator.zsh' >> ~/.zshrc

  # Add colorscheme gruvbox
  echo 'source $HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh' >> ~/.zshrc

  # Change default shell as zsh for root and the current user
  sudo chsh -s /usr/bin/zsh
  sudo chsh -s /usr/bin/zsh $USER

  echo "******************************************************************"
  echo "* Login agin to use zsh powered with zprezto                     *"
  echo "******************************************************************"
}

function init_fzf {
  # Refer to https://github.com/junegunn/fzf
  # Install fzf and enable its key binding
  rm -rf ~/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
}

function init_python {
  # Install pip
  cd /tmp
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python get-pip.py --user

  # Install ipython
  pip install ipython --user

  # Install virtualenvwrapper
  pip install virtualenv --user
  pip install virtualenvwrapper --user
  echo 'source $HOME/.local/bin/virtualenvwrapper.sh' >> ~/.zshrc
}

# Main part
if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 <tmux|zsh|vim>"
  echo
  echo "Notice: this script should be executed with bash!"
  echo
  exit $ERROR_EXIT
else
  INIT_T=$1
fi

if [[ -f /tmp/preparation-done ]]; then
  echo "Base OS preparation is already done"
else
  init_python # pip is needed for prepare stage setup
  file pacman &>/dev/null
  if [ $? -eq 0 ]; then
    # RELEASE='ARCH'
    arch_prepare
  else
    # RELEASE='UBUNTU'
    ubuntu_prepare
  fi
  touch /tmp/preparation-done
fi

if [[ "$INIT_T" = "tmux" ]]; then
  init_tmux
elif [[ "$INIT_T" = "zsh" ]]; then
  init_zprezto
  init_fzf
elif [[ "$INIT_T" = "vim" ]]; then
  init_vim
else
  echo "$INIT_T is not a valid option!"
  exit $ERROR_EXIT
fi
