setopt extendedglob
for script in $ZSHRCDIR/^main.zsh; do
    source "$script"
done


#local overrides n stuff
if [[ -a ~/.localrc ]]; then
  source ~/.localrc
fi
