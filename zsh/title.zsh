autoload zsh/terminfo
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

function title_precmd {
  title zsh "$PWD"
}
[[ -z $precmd_functions ]] && precmd_functions=()
precmd_functions=($precmd_functions title_precmd)

function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
}
