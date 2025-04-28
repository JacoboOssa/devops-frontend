# Frontend Service

UI for sample distributed TODO application. This frontend is built with Vue.js and connects to microservices for authentication and TODO management.

## Features

- User authentication (login/logout)
- Create, read, and delete TODO items
- Responsive design with Bootstrap Vue

## Project Structure

- `src/components` - Vue components
- `src/store` - Vuex store
- `src/router` - Vue Router configuration
- `src/auth.js` - Authentication logic

## Configuration

- `PORT` - Port the application binds to 
- `AUTH_API_ADDRESS` - Address of `auth-api` for authentication
- `TODOS_API_ADDRESS` - Address of `todos-api` for TODO CRUD
- `BASE_API_ADDRESS` - Base address for API gateway (in production)

## Building and Running Locally

### Prerequisites

|  Dependency | Version  |
|-------------|----------|
| Node        | 8.17.0   |
| NPM         | 6.13.4   |

### Development

```bash
# Install dependencies
npm install

# Start development server
PORT=8080 AUTH_API_ADDRESS=http://127.0.0.1:8000 TODOS_API_ADDRESS=http://127.0.0.1:8082 npm start
```

### Production Build

```bash
# Install dependencies
npm install

# Build for production
npm run build
```

## Docker

This project includes a Dockerfile for containerization. The container uses a multi-stage build:
1. Build stage with Node.js
2. Production stage with Nginx for serving static files

```bash
# Build the Docker image
docker build -t frontend .

# Run the container
docker run -p 8080:8080 frontend
```

## CI/CD Pipeline (Azure DevOps)

This project uses Azure DevOps Pipelines for continuous integration and deployment.

### Pipeline Overview

The pipeline is defined in `azure-pipelines.yml` and consists of:

1. **Build Stage:**
   - Builds the frontend Docker image
   - Pushes the image to Azure Container Registry (ACR)

2. **Deployment:**
   - Deploys the image to Azure Container Apps

### Pipeline Configuration

Key variables used in the pipeline:
- `dockerRegistryServiceConnection`: Connection to Azure Container Registry
- `acrLoginServer`: ACR server address (testacrgyvpcp.azurecr.io)
- `containerAppName`: Target Container App name (test-frontend-ca)
- `resourceGroupName`: Azure resource group (rg-app-testing)

### Deployment Process

The pipeline automatically:
1. Triggers on changes to the main branch
2. Builds the Docker image tagged with the build ID
3. Pushes the image to ACR with both the build ID and 'latest' tags
4. Updates the Container App with the new image

## Nginx Configuration

The project includes a custom Nginx configuration (`nginx.conf`) that:
- Routes API requests to appropriate backend services
- Serves static frontend files
- Configures proper caching headers for static assets

## License

This project is part of a microservices architecture example.

## Adding the Pipeline to Azure DevOps

To set up the CI/CD pipeline for this project in Azure DevOps, follow these steps:

### 1. Create a New Pipeline

1. Navigate to your Azure DevOps project.
2. Go to the "Pipelines" section and click on "New Pipeline."
3. Select the repository where your code is hosted (e.g., GitHub, Azure Repos).
4. Choose the option to configure the pipeline using an existing YAML file.
5. Select the `azure-pipelines.yml` file from your repository.

### 2. Set Up Service Connections

1. Go to "Project Settings" > "Service Connections."
2. Create a new service connection for Azure Container Registry (ACR) if not already set up.
3. Ensure the service connection name matches the one referenced in the `azure-pipelines.yml` file (e.g., `dockerRegistryServiceConnection`).

### 3. Configure Pipeline Variables

1. In the pipeline settings, add the required variables:
   - `acrLoginServer`: The login server for your ACR (e.g., `testacrgyvpcp.azurecr.io`).
   - `containerAppName`: The name of your Azure Container App (e.g., `test-frontend-ca`).
   - `resourceGroupName`: The Azure resource group name (e.g., `rg-app-testing`).

### 4. Run the Pipeline

1. Save and run the pipeline.
2. Monitor the pipeline's progress to ensure it builds the Docker image, pushes it to ACR, and deploys it to the Azure Container App.

By following these steps, you can set up and run the CI/CD pipeline for this project in Azure DevOps.