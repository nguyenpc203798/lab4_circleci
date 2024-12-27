FROM golang:1.22-alpine

WORKDIR /circle_ci

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o circle_ci .

EXPOSE 4001

# Command to run the application
CMD ["./circle_ci"]