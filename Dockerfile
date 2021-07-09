FROM gcr.io/distroless/cc

COPY ./target/release/g .

EXPOSE 8000
ENV ROCKET_ADDRESS=0.0.0.0
ENV TZ=Europe/Oslo
ENV RUST_LOG=warn
CMD ["./g"]
