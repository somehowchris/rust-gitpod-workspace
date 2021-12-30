FROM rust:1.57.0

WORKDIR /src

RUN cargo new --lib --name test-me