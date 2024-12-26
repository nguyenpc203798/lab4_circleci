FROM golang:1.23.2-alpine3.20

WORKDIR /devops_final

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o devops_final .

EXPOSE 4000

# Command to run the application
CMD ["./devops_final"]