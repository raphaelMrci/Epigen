##
## EPITECH PROJECT, 2022
## 
## File description:
## Makefile
##

NAME    =   

SRC	=	$(wildcard src/*.c)

SRC_TEST	=	$(wildcard tests/*.c)

OBJ	=	$(SRC:.c=.o)


$(NAME):	$(OBJ)
	make -C ./lib/my
	gcc -o $(NAME) $(OBJ) -L./lib -l my

all:	$(NAME)

clean:
	rm -f $(OBJ)
	rm -f unit_tests*
	make -C ./lib/my clean

fclean:	clean
	rm -f $(NAME)
	make -C ./lib/my fclean

re:	fclean	all

tests_run:	clean
	make -C lib/my re
	gcc -o unit_tests $(SRC) $(SRC_TEST) -lcriterion -L./lib -lmy --coverage
	./unit_tests
