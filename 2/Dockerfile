FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add nasm
RUN apk add make
RUN apk add binutils
RUN make solve1
RUN make solve2
CMD ["./solve1", "data.txt", "&&", "./solve2", "data.txt"]
