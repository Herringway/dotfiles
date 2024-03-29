#!/bin/sh
INSTALLDIR=`realpath $(dirname ${0}$)`
if [ -e ~/.zshrc ]; then
	echo "A .zshrc is already present! Not replacing."
else
	echo export ZSHRCDIR=\"${INSTALLDIR}/zsh/\" >~/.zshrc
	echo source \"\${ZSHRCDIR}/main.zsh\" >>~/.zshrc
fi
if [ -e ~/.nanorc ]; then
	echo "A .nanorc is already present! Not replacing."
else
	ln -s "${INSTALLDIR}/nanorc" ~/.nanorc
fi
if [ -e ~/.gitconfig ]; then
	echo "A .gitconfig is already present! Not replacing."
else
	echo "[include]" >~/.gitconfig
	echo "        path = ${INSTALLDIR}/git/gitconfig-base" >>~/.gitconfig
	echo "        path = ${INSTALLDIR}/git/gitconfig-linux" >>~/.gitconfig
fi
if [ -e ~/.editorconfig ]; then
	echo "An .editorconfig is already present! Not replacing."
else
	ln -s "${INSTALLDIR}/editorconfig" ~/.editorconfig
fi
if [ -e ~/.tmux.conf ]; then
	echo "tmux config is already present! Not replacing."
else
	ln -s "${INSTALLDIR}/tmux.conf" ~/.tmux.conf
fi
