# ---- Build Stage ----
FROM node:20.12-alpine AS build

# Create and set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all source code into the container
COPY . .

# Build the React app for production
RUN npm run build

# ---- Production Stage ----
FROM nginx:stable-alpine

# Copy build output from the previous stage into Nginx's html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Launch Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
