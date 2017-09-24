#!/bin/sh
INSTALLDIR=`realpath -s $(dirname ${0}$)`
if [ -a ~/.zshrc ]; then
	echo "A .zshrc is already present! Not replacing."
else
	echo export ZSHRCDIR=\"${INSTALLDIR}/zsh/\" >~/.zshrc
	echo source \"\${ZSHRCDIR}/main.zsh\" >>~/.zshrc
fi
if [ -a ~/.nanorc ]; then
	echo "A .nanorc is already present! Not replacing."
else
	ln -s "${INSTALLDIR}/nanorc" ~/.nanorc
fi
if [ -a ~/.gitconfig ]; then
	echo "A .gitconfig is already present! Not replacing."
else
	echo "[include]" >~/.gitconfig
	echo "        path = ${INSTALLDIR}/git/gitconfig-base" >>~/.gitconfig
	echo "        path = ${INSTALLDIR}/git/gitconfig-linux" >>~/.gitconfig
fi
