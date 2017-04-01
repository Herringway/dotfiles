autoload zsh/terminfo
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ $TERM == "xterm" || $TERM == "rxvt" || $TERM == "putty" || $TERM == "putty-256color" ]]; then
    # Use this one instead for XTerms:
    print -PnR $'\033]0;'%n@%m: $*$'\a'
  fi
}

function title_precmd {
  title zsh "$PWD"
}

function title_preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
}

add-zsh-hook precmd title_precmd
add-zsh-hook preexec title_preexec
