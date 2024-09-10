# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path
export ZSH="$HOME/.oh-my-zsh"

# Themes
ZSH_THEME="fwalch"
#ZSH_THEME="arrow"

# Plugins
plugins=(git npm systemd postgres gitignore docker docker-compose sudo aliases vscode ubuntu snap golang)

source $ZSH/oh-my-zsh.sh

# ---------------------------------------------------------------------------------------- #
# General
# ------------------------------------------- #
port() {sudo lsof -i :"$1"}

function cpbase64() {
	if [ -z "$1" ]; then
		echo "Usage: cpbase64 <file_to_encode>"
	else base64 -w 0 "$1" | xclip -selection clipboard
		echo "Encoded and copied"
	fi
}

# ------------------------------------------- #
# Basic Aliases
# ------------------------------------------- #
alias sdn='shutdown now'

alias zshrc='nvim ~/.zshrc'
alias szshrc="source ~/.zshrc"

alias vimrc="cd ~/.config/nvim"
alias kittyrc='cd ~/.config/kitty'
alias tmuxrc="nvim ~/.tmux.conf"

alias font-reload='fc-cache -fv'
alias filex='xdg-open .'

# ------------------------------------------- #
# Projects
# ------------------------------------------- #
alias insin-backend='cd /home/rvstank/projects/backend/js/insin-backend'
alias omniapi='cd /home/rvstank/projects/backend/python/omniapi'

# ------------------------------------------- #
# Vim/Terminal
# ------------------------------------------- #
function vim() {
    if [ "$#" -eq 0 ]; then
nvim "$PWD"
    else
nvim "$@"
    fi
}

function ctrl_z_to_fg() {
    fg
}
zle -N ctrl_z_to_fg
bindkey '^Z' ctrl_z_to_fg

# ------------------------------------------- #
# Git/GitHub/GitLab
# ------------------------------------------- #
alias gdn='gd --name-only'
alias gpom='git push -u origin main'

function repo-init() {
    if [ -z "$1" ]; then
        echo "Usage: init-repo <repository-name>"
        return 1
    fi
    local repo_name=$1

    git init || { echo "Failed to initialize git repository"; return 1; }

    gaa
    gcam "init" || { echo "Failed to commit changes"; return 1; }
    git branch -M main

    if command -v gh >/dev/null 2>&1; then
        gh repo create "RVStank/$repo_name" --private --source=. --remote=origin || {
            echo "Failed to create GitHub repository";
            return 1;
        }
    else
        echo "GitHub CLI not found, make sure the repository exists on GitHub."
    fi

    gpom || {
        echo "Failed to push to remote repository";
        return 1;
    }
}

function gitlab-mr-push() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: gitlab_mr_push <branch_name> <target_branch>"
        return 1
    fi
    local branch_name=$1
    local target_branch=$2
    git push -o merge_request.create -o merge_request.target="$target_branch" -u origin "$branch_name"
}

# ------------------------------------------- #
# Docker
# ------------------------------------------- #
alias docker-clear-all='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q) && docker volume rm $(docker volume ls -qf dangling=true)'

# ------------------------------------------- #
# Python3
# ------------------------------------------- #
alias py="python3"
alias pip="py -m pip"
alias pyvenv-create="py -m venv .venv"
alias pyvenv="source .venv/bin/activate"
alias pipfreeze="pip freeze > requirements.txt"
alias pipreq="pip install -r requirements.txt"


# ---------------------------------------------------------------------------------------- #
# Configs
# ------------------------------------------- #
source /home/rvstank/projects/customizations/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="$HOME/.local/bin:$PATH"
fpath+=${ZDOTDIR:-~}/.zsh_functions

export PATH=$PATH:/home/rvstank/.spicetify
export KITTY_ENABLE_WAYLAND=1

export WAYLAND_DISPLAY=wayland-0
export DISPLAY=:0
