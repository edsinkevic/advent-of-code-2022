FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add nasm make binutils
RUN make solve1 solve2
CMD ./solve1 data.txt && ./solve2 data.txt
