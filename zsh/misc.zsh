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
REPORTTIME=10 #if command takes longer than 10s, print stats

[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
export EDITOR=nano
export GPG_TTY=`tty`

[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh
