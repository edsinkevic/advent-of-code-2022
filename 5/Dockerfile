FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add make gcc musl-dev
CMD make main && ./main data.txt
