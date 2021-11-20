#! /bin/bash
 
if ! command -v stow &> /dev/null; then
    echo "stow could not be found"
    exit
else
    echo "- stow found"
fi

appimagesDir="$HOME/.appimages"
if [ ! -d "$appimagesDir" ]; then
    echo "creating '.appimages' directory"
    mkdir -p "$appimagesDir"
else
    echo "- '.appimages' directory found"
fi

nvimAppimage="$appimagesDir/nvim.appimage"
if [ ! -f "$nvimAppimage" ]; then
    nightly="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
    stable="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"

    echo "Which version of neovim do you want to download?"
    echo "1. Stable"
    echo "2. Nightly"
    read -p "Enter your choice [1-2]: " choice

    echo "downloading nvim appimage"
    if [ $choice -eq 1 ]; then
        curl -L "$stable" -o "$nvimAppimage"
    elif [ $choice -eq 2 ]; then
        curl -L "$nightly" -o "$nvimAppimage"
    else
        echo "invalid option"
        exit
    fi
    chmod +x "$nvimAppimage"
else
    echo "- nvim appimage found"
fi

packer="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$packer" ]; then
    echo "- downloading packer"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer"
else
    echo "- packer found"
fi

echo "- installing starship prompt"
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
echo "- starship installed"

ohMyZshDir="$HOME/.oh-my-zsh"
if [ ! -d "$ohMyZshDir" ]; then
    echo "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "- oh-my-zsh installed"
else
    echo "- oh-my-zsh found"
fi

echo "- creating symlinks"
stow nvim
stow starship
stow zsh
echo "- symlinks created"
