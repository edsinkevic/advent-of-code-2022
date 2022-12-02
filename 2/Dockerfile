FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add nasm
RUN apk add make
RUN apk add binutils
RUN make all
CMD ["./main", "data.txt"]
