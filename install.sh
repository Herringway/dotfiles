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
