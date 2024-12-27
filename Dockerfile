FROM golang:1.23.2-alpine3.20

WORKDIR /circle_ci

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o circle_ci .

EXPOSE 4000

# Command to run the application
CMD ["./circle_ci"]