#! /usr/bin/env sh
#  Update settings
git pull

#  Ensure vimrc is linked
ln -s ~/.vim/vimrc ~/.vimrc

# Build mpython_builtins if needed
if [ command -v mpython_qx >& /dev/null ]; then
    if [ ! -f ~/.vimrc/mpython_builtins.ini ]; then
        echo '[flake8]' > ~/.vim/mpython_builtins.ini
        echo 'builtins = M,Case,case,' >> ~/.vim/mpython_builtins.ini
        mpython_qx -c 'import MonteUI; print ",\n".join(name for name in dir(MonteUI.units) if not name.startswith("_")) + ","' >> ~/.vim/mpython_builtins.ini
        mpython_qx -c 'import MonteUI; print ",\n".join(name for name in dir(MonteUI.command) if not name.startswith("_")) + ","' >> ~/.vim/mpython_builtins.ini
        mpython_qx -c 'import MonteUI; print ",\n".join(name for name in dir(MonteUI.setup) if not name.startswith("_"))' >> ~/.vim/mpython_builtins.ini
    fi
fi

# Grab Vundle if needed
if [ ! -d ~/.vimrc/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#  Install plugins
vim +PlugInstall +qall
