#!/usr/bin/bash

rm -r tmp/
mkdir tmp

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
        *)
            NAME=$arg
            ;;
    esac
    shift
done

cd tmp
touch .gitignore
echo $NAME > .gitignore
cat "../gitignore_file" >> .gitignore
mkdir src/
mkdir tests/
mkdir inc/
mkdir lib/
touch Makefile
echo "##
## EPITECH PROJECT, 2022
## $NAME
## File description:
## Makefile
##

NAME    =   $NAME
" > Makefile
cat "../makefile_file" >> Makefile

mkdir lib/my
cd lib/my
cp -r "../../../libmy/" "."
mv libmy/* "."
rm -r libmy
make
make clean
cd ../../inc
touch $NAME.h
echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME header file
*/

#ifndef ${NAME^^}_H_
    #define ${NAME^^}_H_

#endif /*   !${NAME^^}_H_   */
" > $NAME.h



if [ "$print_help" ]; then
    echo "USAGE:
    epitech-gen NAME [OPTIONS]

DESCRIPTION:
    NAME    name for binary delivery file. You can edit project path too

OPTIONS:
    -h, --help          print help
    -g, --csfml         create a csfml project
    -il, --ignore-lib   ignore lib including
    -v, --version       show current version"
    exit 0
fi
