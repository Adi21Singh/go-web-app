FROM golang:1.22.5 as base

WORKDIR /app

## Copy the go.mod and go.sum files to the container
COPY go.mod .

## Download dependencies
RUN go mod download

## Copy the source code into the container
COPY . .

## Build the application
RUN go build -o main .

## FINAL STAGE WITH DISTROLESS IMAGE
FROM gcr.io/distroless/base

## Set the working directory in the container
COPY --from=base /app/main .

## Copy the static files from the base stage to the final image
COPY --from=base /app/static ./static

## Expose the port that the application will run on
EXPOSE 8080

## Run the application
CMD ["./main"]
