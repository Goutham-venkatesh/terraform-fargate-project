# Use Node.js official image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package.json if you have dependencies (optional for hackathon)
# COPY package*.json ./

# Copy service code
COPY patient-service.js .

# Expose port
EXPOSE 3000

# Start service
CMD ["node", "patient-service.js"]