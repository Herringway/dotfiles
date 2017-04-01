setopt extendedglob
for script in $ZSHRCDIR/^main.zsh; do
    source "$script"
done
