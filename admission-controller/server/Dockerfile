# syntax=docker/dockerfile:experimental
# ---
FROM golang:1.16 AS build

WORKDIR /work
COPY . /work

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

# Build admission-webhook
RUN go build -o bin/admission-webhook-linux-amd64 .
# GOOS=darwin GOARCH=amd64 go build -o bin/admission-webhook-darwin-amd64 .
RUN --mount=type=cache,target=/root/.cache/go-build,sharing=private go build -o bin/admission-webhook .


FROM scratch AS run

COPY --from=build /work/bin/admission-webhook /usr/local/bin/

CMD ["admission-webhook"]
