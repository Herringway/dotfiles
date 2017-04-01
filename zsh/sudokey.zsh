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
   if [[ $BUFFER != "$prefix "* ]]; then
      BUFFER="$prefix $BUFFER"
      CURSOR=$(($CURSOR + $#prefix + 1))
   fi
}

zle -N insert-root-prefix
bindkey "^[f" insert-root-prefix
