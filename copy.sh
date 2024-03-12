#!/bin/zsh

MONOKAI_DIR=~/.local/share/nvim/site/pack/packer/start/monokai.nvim/lua

pull () {
    if [[ ! -d "~/.vim/colors" ]]; then
        mkdir -p ~/.vim/colors
    fi

    cp ./vim/colors/sublimemonokai.vim ~/.vim/colors/sublimemonokai.vim

    cp ./vim/vimrc ~/.vimrc
    source ~/.vimrc

    cp ./zsh/zshrc ~/.zshrc
    cp ./zsh/zprofile ~/.zprofile
    cp ./zsh/starship.toml ~/.config/starship.toml

    source ~/.zprofile

    cp ./byobu/bin/* ~/.byobu/bin
    cp ./byobu/.tmux.conf ~/.byobu
    cp ./byobu/keybindings.tmux ~/.byobu
    cp ./byobu/datetime.tmux ~/.byobu
    cp ./byobu/statusrc ~/.byobu

    rm -rf ~/.config/nvim
    cp -r ./nvim ~/.config


    if [[ ! -d $MONOKAI_DIR ]]; then
      mkdir -p $MONOKAI_DIR
    fi

    sudo cp ./fonts/* /Library/Fonts
    cp ./monokai.lua $MONOKAI_DIR

}

push () {
    cp ~/.vimrc ./vim/vimrc
    cp ~/.vim/colors/sublimemonokai.vim ./vim/colors/sublimemonokai.vim

    cp ~/.zprofile ./zsh/zprofile
    cp ~/.zshrc ./zsh/zshrc
    cp ~/.config/starship.toml ./zsh/starship.toml

    cp ~/.byobu/bin/* ./byobu/bin
    cp ~/.byobu/.tmux.conf ./byobu
    cp ~/.byobu/statusrc ./byobu
    cp ~/.byobu/keybindings.tmux ./byobu
    cp ~/.byobu/datetime.tmux ./byobu

    rm -rf ./nvim
    cp -r ~/.config/nvim .
    cp $MONOKAI_DIR/monokai.lua ./monokai.lua
}


git pull

if [[ $1 == "pull" ]]; then
    pull

elif [[ $1 == "push" ]]; then
    push

    git status

    echo
    echo "Press enter if you would like to continue"
    read waitforenter
    echo

    git add -A
    git commit -m "Updating remote config files"
    git push

elif [[ $1 == "init" ]]; then
    pull

    brew install starship
    brew install byobu
    brew install nvim

    sudo cp ./zsh/zsh_completion.d /etc/zsh_completion.d
    sudo cp ./zsh/bash_completion.d /etc/bash_completion.d
    sudo cp ./fonts/* /Library/Fonts

else
    echo "Usage: ./bin/install.sh <pull | push | init>"
fi


