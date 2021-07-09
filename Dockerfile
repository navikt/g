FROM gcr.io/distroless/cc

COPY ./target/release/g .

EXPOSE 8000
ENV RUST_LOG=warn
CMD ["./g"]