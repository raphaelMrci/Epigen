#!/bin/bash

VERSION=0.3.0

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
UNDL='\033[4m'
BLACK='\033[0;30m'
DGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
ORANGE='\033[0;33m'
YELL='\033[1;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
PURPLE='\033[0;35m'
LPURPLE='\033[1;35m'
CYAN='\033[0;36m'
LCYAN='\033[1;36m'
LGREY='\033[0;37m'
WHITE='\033[1;37m'

args_nb=0

TMPDIR='/tmp/Epigen/tmp'

# Clean tmp
clean_tmp() {
    [ -d $TMPDIR ] && rm -r $TMPDIR
    mkdir $TMPDIR
    chmod 777 $TMPDIR/
}

if [ -d /tmp/Epigen ]; then
    echo ""
else
    mkdir /tmp/Epigen
    chmod -R a+wrx /tmp/Epigen
fi

clean_tmp


clean_exit() {
    cp -r $TMPDIR/. "$(pwd)"
    chmod 777 $TMPDIR/
    clean_tmp
    exit 0
}

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
        -vd | --vscode-debug)
            add_debug=true
        ;;
        -ovd | --only-vscode-debug)
            add_debug_only=true
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
    args_nb=$args_nb + 1
done

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
        sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh)"
        exit $?
    fi
    echo -e "
    ${GREEN}Up-to-date.${NC}
"
    exit 0
fi

add_debug_files() {
    mkdir $TMPDIR/.vscode
    echo "{
    // You can add your arguments on 'args' list
    // Don't forget to precise '\${workspaceFolder}' if you want to get a file on your current folder:
    // \"args\": [
    //    \"arg1\",
    //    \"\${workspaceFolder}/map.txt\"
    // ],

    \"version\": \"0.2.0\",
    \"configurations\": [
        {
            \"name\": \"gcc - Epigen generated debugger\",
            \"type\": \"cppdbg\",
            \"request\": \"launch\",
            \"program\": \"\${workspaceFolder}/$NAME\",
            \"args\": [],
            \"stopAtEntry\": false,
            \"cwd\": \"\${workspaceFolder}\",
            \"environment\": [],
            \"externalConsole\": false,
            \"MiMode\": \"gdb\",
            \"setupCommands\": [],
            \"preLaunchTask\": \"Epigen debug task\",
            \"miDebuggerPath\": \"/bin/gdb\"
        }
    ]
}" > $TMPDIR/.vscode/launch.json
    echo "{
    \"tasks\": [
        {
            \"type\": \"cppbuild\",
            \"label\": \"Epigen debug task\",
            \"command\": \"/usr/bin/gcc\",
            \"args\": [
                \"-g\",
                \"\${workspaceFolder}/src/*.c\",
                \"-fdiagnostics-color=always\"," > $TMPDIR/.vscode/tasks.json
    if [ -f "$PWD/lib/my/Makefile" ]; then
        echo "
                \"-L\${workspaceFolder}/lib\",
                \"-lmy\"," >> $TMPDIR/.vscode/tasks.json
    fi
    echo "
                \"-o\",
                \"$NAME\"
            ],
            \"options\": {
                \"cwd\": \"\${workspaceFolder}\"
            },
            \"problemMatcher\": [
                \"\$gcc\"
            ],
            \"group\": {
                \"kind\": \"build\",
                \"isDefault\": true
            },
            \"detail\": \"Task generated by Epigen debugger.\"
        }
    ],
    \"version\": \"2.0.0\"
}" >> $TMPDIR/.vscode/tasks.json
}

if [ $csfml_project ] && [ $python_project ]; then
    echo -e "${RED}Multiple projects types defined. You can't specify more than 1 project type.${NC}"
    exit 84
fi

if [ $print_version ]; then
    echo -e "Current version: ${GREEN}$VERSION${NC}"
    exit 0
fi

if [ "$print_help" ]; then
    echo -e "Epigen ${GREEN}$VERSION${NC}

Epitech project generator developed by Raphael MERCIE - EPITECH Toulouse 2026
Generate Epitech project templates easily

USAGE:
    epigen NAME [OPTIONS]

DESCRIPTION:
    NAME    name for binary delivery file.

OPTIONS:
    -h, --help                  print help
    -g, --csfml                 create a csfml project (TODO)
    -p, --python                create a python project (TODO)
    -il, --ignore-lib           ignore lib include
    -v, --version               show current version
    -l ${UNDL}LIB_PATH${NC}               define your lib path (specify full path)
    -u, --update                update Epigen
    -vd, --vscode-debug         configure vscode debugger on project creation
    -ovd, --only-vscode-debug   configure vscode debugger even if project is already created
                                (for C basic projects. You must ajust 'tasks.json' if you use more libraries)
    "
    exit 0
fi

if [ -z ${NAME+x} ]; then
    read -p "Project name: " NAME
fi

# Set NAME to snake_case norm
NAME=${NAME,,}
NAME=$(echo "$NAME" | sed -r 's/[ ]+/_/g')

if [ "$add_debug_only" ]; then
    if [ $args_nb -gt "1" ]; then
        echo -e "${YELL}You asked to add only vscode debug files. Nothing else will be done due to the '-ovd' or '--only-vscode-debug' option.${NC}"
    fi
    add_debug_files
    clean_exit
fi

# Create all folders #
create_all_folders() {
    mkdir $TMPDIR/src/
    mkdir $TMPDIR/tests/
    mkdir $TMPDIR/inc/
    mkdir $TMPDIR/lib/
}

# .gitignore creation #
add_gitignore() {
    echo $NAME > $TMPDIR/.gitignore
    cat "/usr/local/share/Epigen/gitignore_template" >> $TMPDIR/.gitignore
}

makefile_header() {
    echo "##
## EPITECH PROJECT, 2022
## $NAME
## File description:
## Makefile
##

NAME    =   $NAME
" > $TMPDIR/Makefile
}

header_file() {
    touch $TMPDIR/src/$NAME.h
    echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME header file
*/

#ifndef $(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_
    #define $(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_" > $TMPDIR/src/$NAME.h
}

close_header_file() {
    echo "#endif /*   !$(printf '%s' "$NAME" | awk '{ print toupper($0) }')_H_   */
" >> $TMPDIR/src/$NAME.h
}

main_file() {
    echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** $NAME main file
*/

#include \"$(printf '%s' "$NAME").h\"

int main(int ac, char **av) {
    return (0);
}" > $TMPDIR/src/$NAME.c
}

import_lib() {
    if [ "$ignore_lib" != true ]; then
        if [ -f $HOME/.your_lib ]; then
            mkdir $TMPDIR/lib/my
            rsync -avr --exclude=".git" --exclude=".gitignore" $(cat $HOME/.your_lib)/ $TMPDIR/lib/my
            echo "
    #include \"my.h\"" >> $TMPDIR/src/$NAME.h
            make -C $TMPDIR/lib/my
            make -C $TMPDIR/lib/my clean
        else
            echo "Warning: No lib path was configured. If you want to include your lib, you must use 'epigen -l lib_path'. Try with -h for help.
Use '-il' or '--ignore-lib' to ignore lib import."
            ignore_lib=true
        fi
    fi
}

generate_csfml() {
    create_all_folders
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
" >> $TMPDIR/src/$NAME.h
    close_header_file
    makefile_header
    if [ $ignore_lib ]; then
        cat "/usr/local/share/Epigen/templates/csfml/makefile_template_wthout_lib" >> $TMPDIR/Makefile
    else
        cat "/usr/local/share/Epigen/templates/csfml/makefile_template" >> $TMPDIR/Makefile
    fi
    echo "/*
** EPITECH PROJECT, 2022
** $NAME
** File description:
** CSFML tools
*/

#include \"$(printf '%s' "$NAME").h\"
" > $TMPDIR/src/csfml_tools.c
    cat "/usr/local/share/Epigen/templates/csfml/csfml_tools" >> $TMPDIR/src/csfml_tools.c
    main_file
    mkdir $TMPDIR/sounds
    mkdir $TMPDIR/musics
    mkdir $TMPDIR/fonts
    mkdir $TMPDIR/img
}

generate_basic() {
    create_all_folders
    add_gitignore
    import_lib  # It must add '#include <my.h>' if lib exists #
    makefile_header
    if [ $ignore_lib ]; then
        cat "/usr/local/share/Epigen/templates/basic/makefile_template_wthout_lib" >> $TMPDIR/Makefile
    else
        cat "/usr/local/share/Epigen/templates/basic/makefile_template" >> $TMPDIR/Makefile
    fi
    header_file
    close_header_file
    main_file
}

generate_python() {
    echo "#!/bin/python

" > $TMPDIR/$NAME
}

# Define what project to generate #
if [ $csfml_project ]; then
    generate_csfml
elif [ $python_project ]; then
    generate_python
else
    generate_basic
fi

if [ "$add_debug" ]; then
    add_debug_files
fi

clean_exit
