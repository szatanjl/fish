ARG CARGO=cargo
ARG CARGO_FLAGS=
ARG CARGO_FETCH_FLAGS=

ARG BASEIMG=rust:alpine
ARG BUILDIMG=$BASEIMG
ARG RUNIMG=$BASEIMG


FROM $BUILDIMG AS build
WORKDIR /app
COPY Cargo.toml Cargo.loc[k] .
RUN mkdir src && echo 'fn main(){}' > src/main.rs
ARG CARGO
ARG CARGO_FETCH_FLAGS
RUN ${CARGO} fetch ${CARGO_FETCH_FLAGS}
ARG CARGO_FLAGS
RUN ${CARGO} build -r ${CARGO_FLAGS}
COPY . .
RUN { [ -r version.mk ] && sed '/^$/q; s/^/\t/' version.mk; } || \
    printf '\tNO VERSION\n'
RUN touch src/main.rs
RUN ${CARGO} build -r ${CARGO_FLAGS}


FROM $RUNIMG AS run
WORKDIR /app
COPY --from=build /app/target/release/hello .
CMD ["./hello"]
