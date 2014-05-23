## Installation

* clone repo to `~/.dotfiles` folder:

```
cd ~
git clone https://github.com/harmy/dotfiles.git .dotfiles
```

* create symbolic links to config files

```
ln -s .dotfiles/vimrc .vimrc
ln -s .dotfiles/zshrc-oh-my-zsh .zshrc
ln -s .dotfiles/vim .vim
ln -s .dotfiles/emacs .emacs.d
ln -s .dotfiles/gitconfig .gitconfig
```

## Emacs

* install cask (http://cask.github.io/installation/):

```
curl -fsSkL https://raw.github.com/cask/cask/master/go | python
```

* run cask in `.emacs.d` folder

```
cd ~/.emacs.d
cask
```

* install jedi server

```
M-x jedi:install-server RET
```
