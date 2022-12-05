main.o: main.c stack.h
	gcc -c main.c

stack.o: stack.c
	gcc -c stack.c

main: main.o stack.o
	gcc -o main main.o stack.o

clean:
	rm -rf main *.o

