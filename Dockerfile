# ---- Build Stage ----
# Use a Node.js version compatible with the project requirements (Node 8.17.0 specified in README)
# Using a slightly newer LTS version for better support, adjust if needed.
FROM node:8-alpine AS build-stage

WORKDIR /app

ARG ARG_AUTH_API_ADDRESS
ARG ARG_TODOS_API_ADDRESS

ENV VUE_APP_AUTH_API_ADDRESS=${ARG_AUTH_API_ADDRESS}
ENV VUE_APP_TODOS_API_ADDRESS=${ARG_TODOS_API_ADDRESS}

# Install Python 2 and build tools needed by node-gyp (for node-sass)
RUN apk add --no-cache python2 make g++

COPY package*.json ./
RUN npm install
COPY . .

RUN npm run build

# ---- Production Stage ----
FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy your custom Nginx config to overwrite the default
# Assumes your custom file is named nginx.conf and is in the same directory as the Dockerfile
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the port Nginx will actually listen on
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
