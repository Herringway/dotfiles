autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -U colors && colors
autoload zsh/terminfo
setopt prompt_subst


zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%b%u%c'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:*' stagedstr "$fg[green]*"
zstyle ':vcs_info:*' unstagedstr "$fg[red]*"

function update_git_vars {
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$fg[red][$fg[white]$vcs_info_msg_0_$fg[red]]"
}

#updates vcs info when appropriate command is executed
function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        update_git_vars
        ;;
    esac
}

#update vcs info when dir changes and when a command is about to be executed
add-zsh-hook chpwd update_git_vars
add-zsh-hook preexec preexec_update_git_vars

