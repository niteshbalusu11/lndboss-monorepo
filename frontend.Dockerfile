# ---------------
# Install Dependencies
# ---------------
FROM node:16-alpine as build

WORKDIR /lndboss

COPY frontend/ .
RUN yarn install --network-timeout 1000000

# ---------------
# Build App
# ---------------

ENV NEXT_TELEMETRY_DISABLED=1
RUN yarn build:prod

# ---------------
# Release App
# ---------------
FROM node:16-alpine as final

WORKDIR /lndboss

# Set environment to production
ARG NODE_ENV="production"
ENV NODE_ENV=${NODE_ENV}
ENV NEXT_TELEMETRY_DISABLED=1

RUN touch .env


# Copy NextJS files from build
COPY --from=build /lndboss/package.json ./
COPY --from=build /lndboss/next-env.d.ts ./
COPY --from=build /lndboss/.next ./.next
COPY --from=build /lndboss/public ./public
COPY --from=build /lndboss/next-env.d.ts ./next-env.d.ts
COPY --from=build /lndboss/next.config.js ./next.config.js

# Expose the port the app runs on
EXPOSE 8055

# Start the app
CMD [ "yarn", "start:prod" ]
