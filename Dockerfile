# build environment
FROM node:14 as builder
ENV NODE_ENV production
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
COPY index.js ./
COPY config.js ./

# production environment
FROM public.ecr.aws/lambda/nodejs:14 as final

# Set node environment to production
ENV NODE_ENV production

# Copy js files and change ownership to user node
COPY --from=builder /app/* ${LAMBDA_TASK_ROOT}/

# Use ./dist/bin/www.js as entrypoint
CMD ["index.handler"]
