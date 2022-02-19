#!/bin/bash

VERSION=0.2

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
    chmod -R a+wrx /tmp/Epigen
fi

clean_tmp

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
        -p | --python)
            python_project=true
        ;;
        *)
            if [ $set_lib ]; then
                echo $arg > $HOME/.your_lib
                exit 0
            else
                NAME=$arg
            fi
        ;;
    esac
    shift
done

if [ $csfml_project ] && [ $python_project ]; then
    echo -e "${RED}Multiple projects types defined. You can't specify more than 1 project type.${NC}"
    exit 84
fi

if [ -z ${NAME+x} ]; then
    read -p "Project name: " NAME
fi

if [ $print_version ]; then
    echo -e "Current version: ${GREEN}$VERSION${NC}"
    exit 0
fi

if [ "$print_help" ]; then
    echo -e "Epigen ${GREEN}v$VERSION${NC}

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
    current_version=$(cat /usr/local/share/Epigen/epitech_gen.sh | grep -m 1 "VERSION" | sed 's/VERSION=//g')

    echo "Current version: $current_version"
    if [ $current_version != $updated_version ]; then
        echo -e "
        New version available: ${RED}$updated_version${NC}
        "
        if [[ $EUID -ne 0 ]]; then
            echo "The installation must be run as root."
            echo "Please write sudo before: sudo epigen -u"
            exit 84
        fi
        sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh)"
        exit $?
    fi
    echo -e "
    ${GREEN}Up-to-date.${NC}
"
    exit 0
fi

# Create all folders #
mkdir /tmp/Epigen/tmp/src/
mkdir /tmp/Epigen/tmp/tests/
mkdir /tmp/Epigen/tmp/inc/
mkdir /tmp/Epigen/tmp/lib/

# .gitignore creation #
add_gitignore() {
    echo $NAME > /tmp/Epigen/tmp/.gitignore
    cat "/usr/local/share/Epigen/gitignore_template" >> /tmp/Epigen/tmp/.gitignore
}

makefile_header() {
    echo "##
## EPITECH PROJECT, 2022
## $NAME
## File description:
## Makefile
##

NAME    =   $NAME
" > /tmp/Epigen/tmp/Makefile
}

header_file() {
    touch /tmp/Epigen/tmp/inc/$NAME.h
    echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME header file
*/

#ifndef $(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_
    #define $(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_
" > /tmp/Epigen/tmp/inc/$NAME.h
}

close_header_file() {
    echo "#endif /*   !$(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_   */
" >> /tmp/Epigen/tmp/inc/$NAME.h
}

main_file() {
    echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME main file
*/

#include <$(printf '%s' "$NAME").h>

int main(int ac, char **av) {
    return (0);
}" > /tmp/Epigen/tmp/src/$NAME.c
}

import_lib() {
    if [ "$ignore_lib" != true ]; then
        if [ -f $HOME/.your_lib ]; then
            mkdir /tmp/Epigen/tmp/lib/my
            rsync -avr --exclude=".git" --exclude=".gitignore" $(cat $HOME/.your_lib)/ /tmp/Epigen/tmp/lib/my
            echo "
    #include <my.h>" >> /tmp/Epigen/tmp/inc/$NAME.h
        else
            echo "Warning: No lib path was configured. If you want to include your lib, you must use 'epigen -l lib_path'. Try with -h for help.
Use '-il' or '--ignore-lib' to ignore lib import."
            ignore_lib=true
        fi
    fi
}

generate_csfml() {
    add_gitignore
    header_file
    import_lib  # It must add '#include <my.h>' if lib exists #
    echo "    #include <SFML/Graphics.h>
    #include <SFML/System.h>
    #include <SFML/Window.h>
    #include <SFML/Audio.h>
    #include <stdlib.h>
    #include <SFML/System/Time.h>
    #include <unistd.h>
    #include <time.h>

sfIntRect create_rect(int height, int width, int top, int left);
sfVector2f create_vector2f(float x, float y);
" >> /tmp/Epigen/tmp/inc/$NAME.h
    close_header_file
    makefile_header
    if [ $ignore_lib ]; then
        cat "/usr/local/share/Epigen/templates/csfml/makefile_template_wthout_lib" >> /tmp/Epigen/tmp/Makefile
    else
        cat "/usr/local/share/Epigen/templates/csfml/makefile_template" >> /tmp/Epigen/tmp/Makefile
    fi
    echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** CSFML tools
*/

#include <$(printf '%s' "$NAME").h>

" > /tmp/Epigen/tmp/src/csfml_tools.c
    cat "/usr/local/share/Epigen/templates/csfml/csfml_tools" >> /tmp/Epigen/tmp/src/csfml_tools.c
    main_file
    mkdir /tmp/Epigen/tmp/sounds
    mkdir /tmp/Epigen/tmp/musics
    mkdir /tmp/Epigen/tmp/fonts
    mkdir /tmp/Epigen/tmp/img
}

generate_basic() {
    add_gitignore
    import_lib  # It must add '#include <my.h>' if lib exists #
    makefile_header
    if [ $ignore_lib ]; then
        cat "/usr/local/share/Epigen/templates/basic/makefile_template_wthout_lib" >> /tmp/Epigen/tmp/Makefile
    else
        cat "/usr/local/share/Epigen/templates/basic/makefile_template" >> /tmp/Epigen/tmp/Makefile
    fi
    header_file
    close_header_file
    main_file
}

generate_python() {
    add_gitignore
    echo "#!/bin/python

" > /tmp/Epigen/tmp/$NAME
}

# Define what project to generate #
if [ $csfml_project ]; then
    generate_csfml
elif [ $python_project ]; then
    generate_python
else
    generate_basic
fi

cp -r /tmp/Epigen/tmp/. $(pwd)

clean_tmp
