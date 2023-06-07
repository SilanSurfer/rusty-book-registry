FROM lukemathwalker/cargo-chef:latest AS chef
WORKDIR /app
RUN apt update && apt install lld clangd -y

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release --bin rusty-book-registry

FROM debian:bullseye-slim AS runtime

WORKDIR /app
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists*
COPY --from=builder /app/target/release/rusty-book-registry rusty-book-registry
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT [ "./rusty-book-registry" ]
