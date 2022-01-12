#!/usr/bin/bash

VERSION=0.1

TMPDIR = '/tmp/Epigen'

# Clean tmp
clean_tmp () {
    [ -d $TMPDIR/tmp ] && rm -r $TMPDIR/tmp
    mkdir $TMPDIR/tmp
}

[ -d $TMPDIR ] || mkdir $TMPDIR

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
            ignore-lib=true
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

if [ do_update ]; then
    updated_version = $(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh | grep  "VERSION" | sed 's/VERSION=//g')
    current_version = $(cat /usr/local/lib/Epigen/epitech_gen.sh | grep "VERSION" | sed 's/VERSION=//g')

    echo "Current version: $current_version"
    if [ current_version -ne updated_version]; then
        echo "
        New version available: $updated_version
        "
        if [[ $EUID -ne 0 ]]; then
            echo "The installation must be run as root."
            echo "Please enter your password:"
        fi
        sudo "$0" "sudo sh -c \"$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh)\""
        exit $?
    fi
    exit 0
fi

# Create all folders #
mkdir $TMPDIR/tmp/src/
mkdir $TMPDIR/tmp/tests/
mkdir $TMPDIR/tmp/inc/
mkdir $TMPDIR/tmp/lib/

# .gitignore creation #
echo $NAME > $TMPDIR/tmp/.gitignore
cat "gitignore_file" >> $TMPDIR/tmp/.gitignore

# Makefile creation #
echo "##
## EPITECH PROJECT, 2022
## $NAME
## File description:
## Makefile
##

NAME    =   $NAME
" > $TMPDIR/tmp/Makefile
cat "/usr/local/lib/epitech-gen/makefile_file" >> $TMPDIR/tmp/Makefile

# Lib creation #
if [ -f $HOME/.your_lib ]; then
    mkdir $TMPDIR/tmp/lib/my
    cp -r $(cat $HOME/.your_lib) $TMPDIR/tmp/lib/my
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
" > $TMPDIR/tmp/inc/$NAME.h

cp -r $TMPDIR/tmp/* $(pwd)

if [ "$print_help" ]; then
    echo "USAGE:
    epitech-gen NAME [OPTIONS]

DESCRIPTION:
    NAME    name for binary delivery file.

OPTIONS:
    -h, --help          print help
    -g, --csfml         create a csfml project
    -il, --ignore-lib   ignore lib including
    -v, --version       show current version
    -l                  define your lib path
    -u, --update        update Epigen
"
    exit 0
fi

clean_tmp
