autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload zsh/terminfo
setopt prompt_subst


zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true

FORCE_RUN_VCS_INFO=1

zstyle ':vcs_info:*+pre-get-data:*' hooks pre-get-data
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%b'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

+vi-pre-get-data() {
    # Only Git and Mercurial support and need caching. Abort if any other
    # VCS is used.
    [ "$vcs" != git ] && return

    # If the shell just started up or we changed directories (or for other
    # custom reasons) we must run vcs_info.
    if [[ -n $FORCE_RUN_VCS_INFO ]]; then
        FORCE_RUN_VCS_INFO=
        return
    fi

    # If we got to this point, running vcs_info was not forced, so now we
    # default to not running it and selectively choose when we want to run
    # it (ret=1 means run it, ret=0 means don't).
    ret=1
    # If a git/hg command was run then run vcs_info as the status might
    # need to be updated.
    case "$(fc -ln $(($HISTCMD-1)))" in
        git*)
            ret=0
            ;;
    esac
}
function git_precmd {
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$fg[red][$fg[white]$vcs_info_msg_0_$fg[red]]"
}
[[ -z $precmd_functions ]] && precmd_functions=()
precmd_functions=($precmd_functions git_precmd)

# Must run vcs_info when changing directories.
prompt_chpwd() {
    FORCE_RUN_VCS_INFO=1
}
add-zsh-hook chpwd prompt_chpwd
