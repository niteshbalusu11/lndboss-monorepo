# ---------------
# Install Dependencies
# ---------------
FROM node:16-alpine as build

WORKDIR /lndboss

COPY backend/package.json backend/yarn.lock ./
RUN yarn install --network-timeout 1000000

# ---------------
# Build App
# ---------------

COPY backend/ .
RUN yarn build:prod

# ---------------
# Install Production Dependencies
# ---------------

FROM node:16-alpine as deps

WORKDIR /lndboss

COPY backend/package.json backend/yarn.lock ./

RUN yarn install --production --network-timeout 1000000

# ---------------
# Release App
# ---------------
FROM node:16-alpine as final

WORKDIR /lndboss

# Set environment to production
ARG NODE_ENV="production"
ENV NODE_ENV=${NODE_ENV}

# Create a new user and group
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV USER_ID=$USER_ID
ENV GROUP_ID=$GROUP_ID

RUN touch .env
RUN chown -R $USER_ID:$GROUP_ID /lndboss/

# Copy files from build
COPY --from=build --chown=$USER_ID:$GROUP_ID /lndboss/package.json ./
COPY --from=deps --chown=$USER_ID:$GROUP_ID /lndboss/node_modules/ ./node_modules

# Copy NestJS files from build
COPY --from=build --chown=$USER_ID:$GROUP_ID /lndboss/nest-cli.json ./
COPY --from=build --chown=$USER_ID:$GROUP_ID /lndboss/dist/ ./dist

# Switch to the new user
USER $USER_ID:$GROUP_ID

# Create required directories
# UID / GID 1000 is default for user `node` in the `node:latest` image, this
# way the process will run as a non-root user
RUN mkdir /home/node/.bosgui
RUN mkdir /home/node/.lnd

# Expose the port the app runs on
EXPOSE 8056

# Start the app
CMD [ "yarn", "start:prod" ]
