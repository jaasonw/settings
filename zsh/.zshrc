# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Antigen
source ~/antigen.zsh

# Load Antigen configurations
antigen init ~/.antigenrc

# Example aliases
alias zshconfig="nvim ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ghf="cd ~/github/"
alias ghidra="ghidraRun"
#alias vim='lvim'
#alias nvim='lvim'
alias npm='pnpm'
#alias ls='exa --icons --git -la'
#alias grep='rg'

# PATH variables
export PATH=$PATH:~/.local/bin

#alias cat='bat --theme Nord -Pp'


