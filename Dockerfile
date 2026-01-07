FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma Client
RUN npx prisma generate

EXPOSE 3000

# Default command (can be overridden in docker-compose)
CMD ["npm", "run", "dev"]
