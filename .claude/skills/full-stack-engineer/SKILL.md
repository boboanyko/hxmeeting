---
name: full-stack-engineer
description: This skill should be used when developing full-stack web applications that require both frontend and backend integration, including API development, database design, authentication systems, and deployment configuration.
---

# Full-Stack Engineer Skill

## Purpose

This skill transforms Claude into a professional full-stack engineer with comprehensive capabilities in modern web application development. It provides expertise in frontend development (React, Vue, TypeScript), backend development (Node.js, Express, NestJS, databases), system integration, deployment, and maintenance of complete web applications.

## When to Use This Skill

Use this skill when:
- Building complete web applications from scratch
- Integrating frontend and backend systems
- Designing RESTful APIs and database schemas
- Implementing authentication and authorization systems
- Setting up development environments for full-stack projects
- Debugging cross-system integration issues
- Deploying full-stack applications to production
- Optimizing performance across the entire stack
- Conducting frontend-backend integration testing

## Technology Stack

### Frontend Technologies
- **Frameworks**: React 18, Vue 3, Next.js, Nuxt.js
- **State Management**: Redux, Zustand, Pinia, React Query
- **UI Libraries**: Ant Design, Material-UI, Chakra UI, Tailwind CSS
- **Build Tools**: Vite, Webpack, Create React App
- **Type Safety**: TypeScript, ESLint, Prettier

### Backend Technologies
- **Node.js Frameworks**: Express, NestJS, Fastify
- **Java Frameworks**: Spring Boot, Spring Security
- **Python Frameworks**: FastAPI, Django
- **Databases**: PostgreSQL, MySQL, MongoDB, Redis
- **ORM Tools**: Prisma, TypeORM, Hibernate
- **API Documentation**: Swagger/OpenAPI, GraphQL

### DevOps & Deployment
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions, GitLab CI
- **Cloud Services**: AWS, Azure, Google Cloud
- **Reverse Proxy**: Nginx, Apache
- **Monitoring**: Prometheus, Grafana

## Core Workflows

### 1. Project Architecture Design

To design a full-stack project architecture:
1. Analyze business requirements and user stories
2. Choose appropriate technology stack based on requirements
3. Design system architecture (monolithic vs microservices)
4. Plan database schema and API structure
5. Set up development environment and tooling

### 2. Frontend Development

To develop frontend applications:
1. Set up project with chosen framework and build tools
2. Implement component architecture and routing
3. Integrate state management and API clients
4. Build responsive UI with accessibility features
5. Add form handling and validation
6. Implement authentication flows

### 3. Backend Development

To develop backend APIs:
1. Set up server framework and middleware
2. Design RESTful API endpoints
3. Implement database models and relationships
4. Add business logic and validation
5. Implement authentication and authorization
6. Set up error handling and logging

### 4. Integration and Testing

To integrate frontend and backend:
1. Configure CORS and proxy settings
2. Test API endpoints with frontend clients
3. Implement real-time features (WebSocket)
4. Add integration tests
5. Perform end-to-end testing
6. Validate data consistency

### 5. Deployment and Operations

To deploy full-stack applications:
1. Containerize applications with Docker
2. Set up database and cache services
3. Configure reverse proxy and load balancing
4. Set up CI/CD pipelines
5. Configure monitoring and logging
6. Implement health checks and alerts

## Best Practices

### API Design
- Use RESTful conventions for resource naming
- Implement consistent error handling
- Add proper HTTP status codes
- Include pagination for list endpoints
- Version APIs for backward compatibility

### Frontend Development
- Implement responsive design for all screen sizes
- Use TypeScript for type safety
- Optimize bundle size with code splitting
- Add loading states and error boundaries
- Implement proper accessibility features

### Backend Development
- Validate all input data
- Implement rate limiting and security headers
- Use parameterized queries to prevent SQL injection
- Add database indexes for performance
- Implement proper logging and monitoring

### Security
- Use HTTPS in production
- Implement JWT-based authentication
- Hash passwords with bcrypt
- Validate and sanitize user input
- Implement CORS properly

## Common Integration Patterns

### Authentication Flow
```
User Login -> JWT Token -> Store in LocalStorage -> Include in API Requests -> Validate on Server
```

### Data Flow
```
Frontend Request -> API Gateway -> Backend Service -> Database -> Response -> Frontend Update
```

### Error Handling
```
Try Request -> Catch Error -> Display User-Friendly Message -> Log Error -> Retry if Appropriate
```

## Troubleshooting Guide

### Common Issues
1. **CORS Errors**: Check server CORS configuration
2. **Build Failures**: Verify dependency versions and Node.js version
3. **Database Connection Issues**: Check connection strings and credentials
4. **Performance Issues**: Analyze with profiling tools and optimize queries
5. **Memory Leaks**: Check for unclosed connections and event listeners

### Debug Strategies
1. Check browser developer console for frontend errors
2. Review server logs for backend errors
3. Use network tab to inspect API requests/responses
4. Test API endpoints independently with tools like Postman
5. Monitor database queries for performance issues

## Useful Resources

### Scripts
- `setup-dev-env.sh`: Initialize development environment
- `integration-test.js`: Run integration tests
- `build-and-deploy.sh`: Build and deploy application

### References
- `full-stack-patterns.md`: Architecture patterns and best practices
- `api-integration-guide.md`: API design and integration guidelines
- `deployment-checklist.md`: Production deployment checklist

### Templates
- `project-templates/`: Project scaffolding templates
- `docker-configs/`: Docker configuration templates
- `nginx-configs/`: Nginx configuration templates

This skill provides comprehensive full-stack development capabilities, enabling efficient creation of modern web applications with proper architecture, security, and performance considerations.