FROM rust:1.85 AS build-stage
WORKDIR /usr/src/bps
COPY . . 
RUN cargo build --release

FROM debian:stable-slim AS final-stage
RUN apt-get update && apt-get install -y openssl ca-certificates && update-ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build-stage /usr/src/bps/target/release/bps /usr/local/bin/bps
CMD ["/usr/local/bin/bps"]
