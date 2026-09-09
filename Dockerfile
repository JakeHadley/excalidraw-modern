# syntax=docker/dockerfile:1

# Modern official Excalidraw client (pinned v0.18.1) with self-hosted
# backend URLs baked in at build time.
#
# Set these as Coolify BUILD-TIME env vars (is_build_time=true):
#   VITE_APP_BACKEND_V2_GET_URL   e.g. http://192.168.50.98:3103/api/v2/scenes/
#   VITE_APP_BACKEND_V2_POST_URL  same base (backend POST returns {id})
#   VITE_APP_WS_SERVER_URL        e.g. http://192.168.50.98:3102/
#   VITE_APP_ENABLE_TRACKING      false

FROM node:24-alpine AS build
WORKDIR /opt/node_app

ARG VITE_APP_BACKEND_V2_GET_URL
ARG VITE_APP_BACKEND_V2_POST_URL
ARG VITE_APP_WS_SERVER_URL
ARG VITE_APP_LIBRARY_URL
ARG VITE_APP_ENABLE_TRACKING=false
ARG NODE_ENV=production

ENV VITE_APP_BACKEND_V2_GET_URL=$VITE_APP_BACKEND_V2_GET_URL \
    VITE_APP_BACKEND_V2_POST_URL=$VITE_APP_BACKEND_V2_POST_URL \
    VITE_APP_WS_SERVER_URL=$VITE_APP_WS_SERVER_URL \
    VITE_APP_LIBRARY_URL=$VITE_APP_LIBRARY_URL \
    VITE_APP_ENABLE_TRACKING=$VITE_APP_ENABLE_TRACKING \
    NODE_ENV=$NODE_ENV

RUN apk add --no-cache git && \
    git clone --depth 1 --branch v0.18.1 https://github.com/excalidraw/excalidraw.git . && \
    rm -rf .git

RUN yarn --frozen-lockfile --network-timeout 600000

RUN yarn build:app:docker

FROM nginx:stable-alpine-slim
COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html
HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1