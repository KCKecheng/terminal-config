#!/bin/bash

export PATH="/home/$USER/.local/bin:$PATH"

ABS_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$ABS_PATH")
ERROR_EXIT=1

function arch_prepare {
  # Install which
  pacman -Q which || sudo pacman -S --noconfirm which

  # Install curl for file downloading
  pacman -Q curl || sudo pacman -S --noconfirm curl

  # Install tmux
  pacman -Q tmux || sudo pacman -S --noconfirm tmux
  # Install tmuxinator
  #sudo pacman -S --noconfirm ruby-native-package-installer
  #gem install tmuxinator
  # Install tmuxp
  $PIP install --user tmuxp

  # Install sytax checker for syntastic
  pacman -Q flake8 || sudo pacman -S --noconfirm flake8
  pacman -Q shellcheck ||sudo pacman -S --noconfirm shellcheck

  # Install ripgrep for Rg command in vim-fzf
  pacman -Q ripgrep || sudo pacman -S --noconfirm ripgrep

  # Install ctags
  pacman -Q ctags || sudo pacman -S --noconfirm ctags

  # Install cscope
  pacman -Q cscope || sudo pacman -S --noconfirm cscope

  # Install zsh
  pacman -Q zsh || sudo pacman -S --noconfirm zsh

  # Install vim
  pacman -Q vim || sudo pacman -S --noconfirm vim

  # Install fasd
  pacman -Q fasd || sudo pacman -S --noconfirm fasd

  # Install make, gcc, etc. for YCM compilation
  pacman -Q cmake || sudo pacman -S --noconfirm cmake
  pacman -Q make || sudo pacman -S --noconfirm make
  pacman -Q gcc || sudo pacman -S --noconfirm gcc

  # Install external formatter for vim-autoformat
  # sudo pacman -S --noconfirm autopep8
  # sudo pacman -S --noconfirm python-black
  $PIP install --user black
  pacman -Q tidy || sudo pacman -S --noconfirm tidy
  pacman -Q npm || sudo pacman -S --noconfirm npm
  sudo npm install -g js-beautify
  sudo npm install -g remark-cli

  # Install shfmt
  # sudo pacman -S --noconfirm base-devel
  # sudo reboot
  # sudo pacman -S --noconfirm go
  # sudo pacman -S --noconfirm yaourt
  # yaourt -S shfmt
}

function ubuntu_prepare {
  # Add PPA for vim-nox and ripgrep
  sudo add-apt-repository ppa:pi-rho/dev
  sudo add-apt-repository ppa:x4121/ripgrep
  sudo apt update

  # Install curl for file downloading
  dpkg -l curl || sudo apt install curl

  # Install tmux and tmux session manager(tmuxinator or tmuxp)
  dpkg -l tmux || sudo apt install -y tmux
  #sudo apt install -y tmuxinator
  dpkg -l tmuxp || sudo apt install -y tmuxp

  # Intall vim-nox which contains more features
  dpkg -l vim-nox || sudo apt install -y vim-nox

  # Install sytax checker for syntastic
  dpkg -l flake8 || sudo apt install -y flake8
  dpkg -l yamllint || sudo apt install -y yamllint
  dpkg -l shellcheck || sudo apt install -y shellcheck

  # Install ripgrep for Rg command in vim-fzf
  dpkg -l ripgrep || sudo apt install ripgrep

  # Install ctags
  dpkg -l ctags || sudo apt install ctags

  # Install cscope
  dpkg -l cscope || sudo apt install cscope

  # Install packages for YCM language support compiling
  dpkg -l build-essential || sudo apt-get install build-essential
  dpkg -l cmake || sudo apt install cmake
  dpkg -l python-dev | sudo apt install python-dev
  dpkg -l python3-dev | sudo apt install python3-dev

  # Install zsh
  dpkg -l zsh || sudo apt install zsh

  # Install vim
  dpkg -l vim || sudo apt intall vim
}

function centos_prepare {
  # Install curl for file downloading
  rpm -q curl || sudo yum install -y curl

  # Install tmux and tmux session manager(tmuxinator or tmuxp)
  rpm -q tmux || sudo yum install -y tmux
  $PIP install --user tmuxp

  # Install sytax checker for syntastic
  $PIP install --user flake8
  sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/petersen/ShellCheck/repo/epel-7/petersen-ShellCheck-epel-7.repo
  rpm -q ShellCheck || sudo yum install -y ShellCheck

  # Install ripgrep for Rg command in vim-fzf
  sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
  rpm -q ripgrep || sudo yum install -y ripgrep

  # Install ctags
  rpm -q ctags || sudo yum install -y ctags

  # Install cscope
  rpm -q cscope || sudo yum install -y cscope

  # Install zsh
  rpm -q zsh || sudo yum install -y zsh

  # Install vim
  rpm -q vim || sudo yum install -y vim-enhanced

  # Install fasd
  sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/rdnetto/fasd/repo/fedora-33/rdnetto-fasd-fedora-33.repo
  rpm -q fasd || sudo yum install -y fasd

  # Install make, gcc, etc. for YCM compilation
  rpm -q cmake || sudo yum install -y cmake
  rpm -q make || sudo yum install -y make
  rpm -q gcc || sudo yum install -y gcc

  # Install external formatter for vim-autoformat
  $PIP install --user black
  rpm -q tidy || sudo yum install -y tidy
  rpm -q npm || sudo yum install -y npm
  sudo npm install -g js-beautify
  sudo npm install -g remark-cli
}

function init_tmux {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  cp "$SCRIPT_DIR/conf/tmux.conf" ~/.tmux.conf

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
  cp "$SCRIPT_DIR/conf/vimrc.vim-plug" ~/.vimrc

  # Vista supports lsp which covers tags related showcase
  # # Install rst2ctags and markdown2ctags to support rst and md tags
  # sudo pacman -S --noconfirm rst2ctags || sudo apt install rst2ctags
  # $PIP install --user markdown2ctags
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
  vim "+helptags ~/.vim/doc" "+qall"

  # Enable gruvbox colorscheme
  sed -i 's/# colorscheme gruvbox/colorscheme gruvbox/' ~/.vimrc
}

function init_zprezto {
  # Clean potential conflicts
  rm -rf "$HOME/.zprezto"
  rm -rf "$HOME"/.zsh*
  rm -rf "$HOME"/.prezto*

  # Refer to https://github.com/sorin-ionescu/prezto on how to configure prezto
  # To upgrade zprezto:
  # - automatic update: zprezto-update
  # - manual update   : cd $ZPREZTODIR; git pull && git submodule update --init --recursive

  # Clone zprezto
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"

  for rcfile in "$HOME"/.zprezto/runcoms/*; do
    f_name=$(basename "$rcfile")
    if [[ "$f_name" != "README.md" ]]; then
      ln -s -f "$rcfile" "$HOME/.$f_name"
    fi
  done

  cp "$SCRIPT_DIR/conf/zpreztorc" ~/.zpreztorc

  # # The highlight color won't work by default
  # echo 'export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"' >> ~/.zshrc
  #
  # # Set vim as the default editor instead of nano
  # echo 'export EDITOR="vim"' >> ~/.zshrc
  #
  # # Add cargo bin path where ripgrep will be installed
  # echo 'export PATH=$PATH:~/.cargo/bin' >> ~/.zshrc
  cp "$SCRIPT_DIR/conf/zshrc" ~/.zshrc

  # Append tmuxinator completion
  #echo 'source $HOME/.tmux/plugins/tmuxinator/completion/tmuxinator.zsh' >> ~/.zshrc

  # Add colorscheme gruvbox
  echo 'source $HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh' >> ~/.zshrc

  # Change default shell as zsh for root and the current user
  sudo chsh -s /usr/bin/zsh
  sudo chsh -s /usr/bin/zsh "$USER"

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
  if [ "$PIP" = "" ]; then
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    python3 /tmp/get-pip.py --user
    sudo ln -s "/home/$USER/.local/bin/pip" /usr/local/bin/
    sudo ln -s "/home/$USER/.local/bin/pip3" /usr/local/bin/
    export PIP="pip3"
  fi

  # Install ipython
  $PIP install --user ipython

  # Install virtualenvwrapper
  $PIP install --user virtualenv
  $PIP install --user virtualenvwrapper
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

# pip selection - pip3 as default when it is installed
pip3 -V &>/dev/null && export PIP="pip3"
if [ "$PIP" = "" ]; then
  pip -V &>/dev/null && export PIP="pip"
fi

if [[ -f /tmp/preparation-done ]]; then
  echo "Base OS preparation is already done"
else
  init_python # pip is needed for prepare stage setup
  ls /usr/bin/pacman &>/dev/null && arch_prepare
  ls /usr/bin/apt &>/dev/null && ubuntu_prepare
  ls /usr/bin/yum &>/dev/null && centos_prepare
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
