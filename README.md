# VimRC setup
This is my vim setup

The vimrc file should be symlinked to ~/.vimrc. Then vim-plug should be
installed using the command using:

```
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

For Monte, a file ~/.vim/mpython_builtins.ini should be built by adding data to
the existing file. This is best done with a script.

All of this can be done by running "./setup.sh". This is recommended.
