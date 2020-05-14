# base on ghost:3-alpine https://github.com/docker-library/ghost
FROM node:12-alpine3.11

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache \
  # add "bash" for "[["
  bash

ENV NODE_ENV production

ENV GHOST_CLI_VERSION 1.13.1
RUN set -eux; \
  npm install -g "ghost-cli@$GHOST_CLI_VERSION"; \
  npm cache clean --force

ENV GHOST_INSTALL /var/lib/ghost
ENV GHOST_CONTENT /var/lib/ghost/content

ENV GHOST_VERSION 3.15.3

RUN set -eux; \
  mkdir -p "$GHOST_INSTALL"; \
  chown node:node "$GHOST_INSTALL"; \
  \
  su-exec node ghost install "$GHOST_VERSION" --db sqlite3 --no-prompt --no-stack --no-setup --dir "$GHOST_INSTALL"; \
  \
  # Tell Ghost to listen on all ips and not prompt for additional configuration
  cd "$GHOST_INSTALL"; \
  su-exec node ghost config --ip 0.0.0.0 --port 2368 --no-prompt --db sqlite3 --url http://localhost:2368 --dbpath "$GHOST_CONTENT/data/ghost.db"; \
  su-exec node ghost config paths.contentPath "$GHOST_CONTENT"; \
  \
  # make a config.json symlink for NODE_ENV=development (and sanity check that it's correct)
  su-exec node ln -s config.production.json "$GHOST_INSTALL/config.development.json"; \
  readlink -f "$GHOST_INSTALL/config.development.json"; \
  \
  # save initial content folder
  cp -r "$GHOST_CONTENT" "$GHOST_INSTALL/content.orig"; \
  \
  # intall ghost-storage-adapter-s3
  npm install ghost-storage-adapter-s3; \
  mkdir -p "$GHOST_CONTENT/adapters/storage"; \
  cp -vr "$GHOST_INSTALL/node_modules/ghost-storage-adapter-s3" "$GHOST_CONTENT/adapters/storage/ghost-s3"; \
  \
  su-exec node yarn cache clean; \
  su-exec node npm cache clean --force; \
  npm cache clean --force; \
  rm -rv /tmp/yarn* /tmp/v8*

WORKDIR $GHOST_INSTALL

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 2368
CMD ["node", "current/index.js"]
