FROM ruby:2.6.4-alpine
RUN apk add --update --no-cache \
    ca-certificates \
    openssl \
    g++ \
    gcc \
    libc-dev \
    make \
    patch \
    imagemagick \
    sqlite-dev \
  && rm -rf /var/cache/apk/*
ENV USER=ruby
ENV UID=1000
ENV GID=1000
RUN adduser -Du "$UID" "$USER" && \
    addgroup "$USER" "root"
USER $USER
ENV GEM_HOME=/app/.bundle
ENV PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"
WORKDIR /app
ADD . /app
ENV PORT=3000
ENV HOST=0.0.0.0
ENTRYPOINT [ "scripts/run" ]