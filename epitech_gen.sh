#!/usr/bin/bash

VERSION=0.1

# Clean tmp
clean_tmp () {
    [ -d /tmp/epitech-gen/tmp ] && rm -r /tmp/epitech-gen/tmp
    mkdir /tmp/epitech-gen/tmp
}

[ -d /tmp/epitech-gen ] || mkdir /tmp/epitech-gen

clean_tmp

if [ $# -lt 1 ]; then
    echo "Project name: "
    read NAME
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
            ignore-lib=true
            ;;
        -v | --version)
            print_version=true
            ;;
        -l)
            set_lib=true
            ;;
        *)
            if [ set_lib ]; then
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
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    GREEN='\033[0;32m'
    echo -e "Current version: ${GREEN}$VERSION${NC}"
    echo Hum.
fi

# Create all folders #
mkdir /tmp/epitech-gen/tmp/src/
mkdir /tmp/epitech-gen/tmp/tests/
mkdir /tmp/epitech-gen/tmp/inc/
mkdir /tmp/epitech-gen/tmp/lib/

# .gitignore creation #
echo $NAME > /tmp/epitech-gen/tmp/.gitignore
cat "gitignore_file" >> /tmp/epitech-gen/tmp/.gitignore

# Makefile creation #
echo "##
## EPITECH PROJECT, 2022
## $NAME
## File description:
## Makefile
##

NAME    =   $NAME
" > /tmp/epitech-gen/tmp/Makefile
cat "/usr/local/lib/epitech-gen/makefile_file" >> /tmp/epitech-gen/tmp/Makefile

# Lib creation #
if [ -f $HOME/.your_lib ]; then
    mkdir /tmp/epitech-gen/tmp/lib/my
    cp -r $(cat $HOME/.your_lib) /tmp/epitech-gen/tmp/lib/my
else
    echo "Warning: No lib path was configured. If you want to include your lib, you must use 'epitech-gen -l lib_path'. Try with -h for help."
fi
echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME header file
*/

#ifndef ${NAME^^}_H_
    #define ${NAME^^}_H_

#endif /*   !${NAME^^}_H_   */
" > /tmp/epitech-gen/tmp/inc/$NAME.h

cp -r /tmp/epitech-gen/tmp/* $(pwd)

if [ "$print_help" ]; then
    echo "USAGE:
    epitech-gen NAME [OPTIONS]

DESCRIPTION:
    NAME    name for binary delivery file. You can edit project path too

OPTIONS:
    -h, --help          print help
    -g, --csfml         create a csfml project
    -il, --ignore-lib   ignore lib including
    -v, --version       show current version
    -l                  define your lib path
"
    exit 0
fi

clean_tmp
