# Use the official Golang image to create a binary.
FROM golang:1.20 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Update the Go version to match the valid format
RUN sed -i 's/1.24.2/1.20/' go.mod

# Download all dependencies. Dependencies are cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY ./cmd .

# Build the Go app
RUN go build -o goapp9

# Use a minimal image for the final artifact
FROM golang:1.23-bookworm

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/goapp9 .

# Command to run the executable
CMD ["./goapp9"]