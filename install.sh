INSTALLDIR=`realpath -s $(dirname ${0}$)`
echo export ZSHRCDIR=\"${INSTALLDIR}/zsh/\" >~/.zshrc
echo source \"\${ZSHRCDIR}/main.zsh\" >>~/.zshrc
