# nvim-config

# Setup

Install [NeoVim](https://github.com/neovim/neovim/blob/master/INSTALL.md)

```
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
```

Clone [Packer](https://github.com/wbthomason/packer.nvim)

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Install [FZF](https://github.com/junegunn/fzf)

```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```


Install [NPM](https://github.com/nvm-sh/nvm)

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install node
```

### Install the following utilities to `~/.local/bin

Install [ripgrep](https://github.com/BurntSushi/ripgrep/releases)

Install [tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer)

Install [black[(https://github.com/psf/black/releases/tag/24.2.0)

## Install NeoVim Configuration

```
mkdir -p ~/.config/nvim
cp -r * ~/.config/nvim/
```

## COC Configuration

### Install Extensions

```
:CocInstall coc-jedi coc-diagnostic
```

### Configure Extensions

```
{
    "python.formatting.provider":"black",
	"python.formatting.blackPath": "~/.local/bin/black",
	"coc.preferences.formatOnSaveFiletypes": [
		"python",
		"json"
	],
    "diagnostic-languageserver.formatFiletypes": {
      "python": ["black"],
    },
    "diagnostic-languageserver.formatters": {
      "black": {
        "command": "black",
        "args": ["-q", "--line-length", "100", "-"]
      }
    }
}
```
