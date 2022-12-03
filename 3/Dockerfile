FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add gfortran libc-dev
RUN gfortran -ffree-form -c funcs.f solve1.f solve2.f 
RUN gfortran -o solve1 funcs.o solve1.o
RUN gfortran -o solve2 funcs.o solve2.o
CMD ./solve1 && ./solve2
