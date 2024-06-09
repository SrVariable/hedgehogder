#!/bin/bash
# ./set_header.sh

# Set variables

if [ ! -z "$USER" ]
then
    echo "USER=`/usr/bin/whoami`" >> ~/.${SHELL##/bin/}rc
    echo "export USER" >> ~/.${SHELL##/bin/}rc
fi

if [ ! -z "$GROUP" ]
then
    echo "GROUP=`/usr/bin/id -gn $user`" >> ~/.${SHELL##/bin/}rc
    echo "export GROUP" >> ~/.${SHELL##/bin/}rc
fi

if [ ! -z "$MAIL" ]
then
    echo "MAIL="$USER@student.42.fr"" >> ~/.${SHELL##/bin/}rc
    echo "export MAIL" >> ~/.${SHELL##/bin/}rc
fi

mkdir -p ~/.vim/plugin

# Add stdheader to vim plugins
cp plugin/hedgehogder.vim ~/.vim/plugin/

source ~/.${SHELL##/bin/}rc
