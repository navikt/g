FROM rust:1.53-slim AS builder

WORKDIR /app

RUN USER=root cargo new --bin g
WORKDIR /app/g
COPY Cargo.toml Cargo.lock grunnbeløp.json ./

RUN cargo build --release
RUN rm src/*.rs

RUN rm target/release/deps/g*

COPY src ./src

RUN cargo install --path .

FROM scratch
COPY --from=builder /app/g/bin/g .
USER 64666

CMD [ "./g" ]