FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add gfortran libc-dev
RUN gfortran -ffree-form -c funcs.f main.f && gfortran -o main funcs.o main.o
CMD ./main data.txt
