COMPL = nvcc
FLAGS = -lm -lGL -lGLU -lglut

main: main.o
	$(COMPL) -o main main.o $(FLAGS)

main.o: main.cu
	$(COMPL) -c main.cu $(FLAGS) 

