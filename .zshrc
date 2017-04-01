HISTFILE=~/.histfile
HISTSIZE=SAVEHIST=10000
setopt inc_append_history
setopt extended_history
bindkey -e

autoload -Uz compinit
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload zsh/terminfo
autoload -U colors && colors
compinit
setopt prompt_subst

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


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
alias sudo='sudo '
case $(uname -s) in
  "FreeBSD")
   alias ls='ls -Gh'
   alias grep='grep --color=always'
  ;;
  *)
   alias ls='ls --color=auto -h'
   alias grep='grep --color'
   alias cp='cp --reflink=auto'
  ;;
esac
PROMPT="%(#.%F{red}.%F{cyan})%n@%m:%F{white}%~\$psvar[1]%F{cyan}%#%f "
RPROMPT="%F{cyan}[%B%F{white}%D{%H}%b:%D{%M}:%D{%S}%F{cyan}]%f"
REPORTTIME=10 #if command takes longer than 10s, print stats

insert-root-prefix () {
   local prefix
   case $(uname -s) in
      "SunOS")
         prefix="pfexec"
      ;;
      *)
         prefix="sudo"
      ;;
   esac
   BUFFER="$prefix $BUFFER"
   CURSOR=$(($CURSOR + $#prefix + 1))
}

zle -N insert-root-prefix
bindkey "^[f" insert-root-prefix
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ $TERM == "xterm" || $TERM == "rxvt" ]]; then
    # Use this one instead for XTerms:
    print -PnR $'\033]0;'%n@%m: $*$'\a'
  fi
}

function precmd {
  title zsh "$PWD"
  psvar=()

  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$fg[red][$fg[white]$vcs_info_msg_0_$fg[red]]"
}

function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
}

# Must run vcs_info when changing directories.
prompt_chpwd() {
    FORCE_RUN_VCS_INFO=1
}
add-zsh-hook chpwd prompt_chpwd

[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
export EDITOR=nano
export GPG_TTY=`tty`

autoload zkbd
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh
