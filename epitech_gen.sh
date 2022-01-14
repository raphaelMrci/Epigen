#!/bin/bash

VERSION=0.1-alpha

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

# Clean tmp
clean_tmp () {
    [ -d /tmp/Epigen/tmp ] && rm -r /tmp/Epigen/tmp
    mkdir /tmp/Epigen/tmp
}

if [ -d /tmp/Epigen ]; then
    echo ""
else
    mkdir /tmp/Epigen
    chmod -R 777 /tmp/Epigen
fi

clean_tmp

if [ $# -lt 1 ]; then
    read -p "Project name: " NAME
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
        -h | --help)
            print_help=true
            ;;
        -g | --csfml)
            csfml_project=true
            ;;
        -il | --ignore-lib)
            ignore_lib=true
            ;;
        -v | --version)
            print_version=true
            ;;
        -l)
            set_lib=true
            ;;
        -u | --update)
            do_update=true
            ;;
        *)
            if [ $set_lib ]; then
                echo $arg > $HOME/.your_lib
                set_lib=false
            else
                NAME=$arg
            fi
            ;;
    esac
    shift
done

if [ $print_version ]; then
    echo -e "Current version: ${GREEN}$VERSION${NC}"
    exit 0
fi

if [ "$print_help" ]; then
    echo "Epigen v$VERSION

Epitech project generator developed by Raphael MERCIE - EPITECH Toulouse 2026
Generate Epitech project templates easily

USAGE:
    epigen NAME [OPTIONS]

DESCRIPTION:
    NAME    name for binary delivery file.

OPTIONS:
    -h, --help          print help
    -g, --csfml         create a csfml project (TODO)
    -p, --python        create a python project (TODO)
    -il, --ignore-lib   ignore lib include
    -v, --version       show current version
    -l \e[4mLIB_PATH\e[0m         define your lib path (specify full path)
    -u, --update        update Epigen
"
    exit 0
fi

if [ $do_update ]; then
    updated_version=$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh | grep  "VERSION" | sed 's/VERSION=//g')
    current_version=$(cat /usr/local/lib/Epigen/epitech_gen.sh | grep -m 1 "VERSION" | sed 's/VERSION=//g')

    echo "Current version: $current_version"
    if [ $current_version != $updated_version ]; then
        echo "
        New version available: $updated_version
        "
        if [[ $EUID -ne 0 ]]; then
            echo "The installation must be run as root."
            echo "Please write sudo before: sudo epigen -u"
            exit 84
        fi
        sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh)"
        exit $?
    fi
    echo "
    Up-to-date.
"
    exit 0
fi

# Create all folders #
mkdir /tmp/Epigen/tmp/src/
mkdir /tmp/Epigen/tmp/tests/
mkdir /tmp/Epigen/tmp/inc/
mkdir /tmp/Epigen/tmp/lib/

# .gitignore creation #
echo $NAME > /tmp/Epigen/tmp/.gitignore
cat "/usr/local/lib/Epigen/gitignore_file" >> /tmp/Epigen/tmp/.gitignore

# Makefile creation #
echo "##
## EPITECH PROJECT, 2022
## $NAME
## File description:
## Makefile
##

NAME    =   $NAME
" > /tmp/Epigen/tmp/Makefile
cat "/usr/local/lib/Epigen/makefile_file" >> /tmp/Epigen/tmp/Makefile

# Lib creation #
if [ "$ignore_lib" = false ]; then
    if [ -f $HOME/.your_lib ]; then
        mkdir /tmp/Epigen/tmp/lib/my
        cp -r $(cat $HOME/.your_lib) /tmp/Epigen/tmp/lib/my
    else
        echo "Warning: No lib path was configured. If you want to include your lib, you must use 'epigen -l lib_path'. Try with -h for help."
    fi
fi

touch /tmp/Epigen/tmp/inc/$NAME.h
echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME header file
*/

#ifndef $(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_
    #define $(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_

#endif /*   !$(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_   */
" > /tmp/Epigen/tmp/inc/$NAME.h

cp -r /tmp/Epigen/tmp/. $(pwd)

clean_tmp
