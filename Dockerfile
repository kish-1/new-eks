# Use official Node.js base image
FROM node:18

# Create non-root user
RUN groupadd -r nodeapp && useradd -r -g nodeapp nodeuser

# Set working directory
WORKDIR /app

# Copy app source
COPY . .

# Install dependencies
RUN npm install

# Change ownership (good practice)
RUN chown -R nodeuser:nodeapp /app

# Use non-root user
USER nodeuser

# Expose app port
EXPOSE 3000

# Run app
CMD ["npm", "start"]

