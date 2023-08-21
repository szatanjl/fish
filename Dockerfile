ARG CARGO=cargo
ARG CARGO_FLAGS=
ARG CARGO_FETCH_FLAGS=

ARG BASEIMG=rust:alpine
ARG BUILDIMG=$BASEIMG
ARG RUNIMG=$BASEIMG


FROM $BUILDIMG AS build
WORKDIR /app
RUN apk add --no-cache musl-dev openssl-dev
COPY Cargo.toml Cargo.loc[k] .
RUN mkdir src && echo '' > src/lib.rs && \
    echo 'fn main(){}' > src/fish.rs && \
    echo 'fn main(){}' > src/fishd.rs
ARG CARGO
ARG CARGO_FETCH_FLAGS
ENV RUSTFLAGS="-C target-feature=-crt-static"
RUN ${CARGO} fetch ${CARGO_FETCH_FLAGS}
ARG CARGO_FLAGS
RUN ${CARGO} build -r ${CARGO_FLAGS}
COPY . .
RUN { [ -r version.mk ] && sed '/^$/q; s/^/\t/' version.mk; } || \
    printf '\tNO VERSION\n'
RUN touch src/lib.rs src/fish.rs src/fishd.rs
RUN ${CARGO} build -r ${CARGO_FLAGS}


FROM $RUNIMG AS run
WORKDIR /app
COPY --from=build /app/target/release/fishd .
COPY --from=build /app/target/release/fish .
CMD ["./fishd"]
