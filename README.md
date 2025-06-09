# Project Overview

This project implements a complete e-commerce wishlist system with:

Vapor backend API
MongoDB database
iOS client application
System Architecture

### **WishlistApp**
├── Server/ (VaporBackend)<br/>
├── Client/ (iOS app)<br/>
└── README.md<br/>

Database Setup (MongoDB)

## **Using Docker**
Ensure Docker is installed and running

Run MongoDB with authentication:<br/>
```
bash:
docker run -d --name mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=example \
  -e MONGO_INITDB_DATABASE=wishlist \
  mongo:latest
```
  
Verify the container is running:
```
bash:
docker ps
```

Connect to MongoDB shell:
```
bash:
docker exec -it mongodb mongosh -u root -p example --authenticationDatabase admin
```

# **Vapor Server Setup**

## Prerequisites

Swift 5.8+<br/>
Vapor 4.0+<br/>
MongoDB 8.0+<br/>
Installation<br/>

## Clone the repository
Navigate to the Vapor Server directory:
```
bash:
cd VaporBackend
```

Build and run:
```
bash
swift build
swift run
```

### Environment Variables
Create a .env file in the Vapor Server directory:<br/>
```
DATABASE_URL=mongodb://root:example@localhost:27017/wishlist?authSource=admin
```

## API Endpoints
```
GET /products - Get all products
GET /wishlist/{userID} - Get user's wishlist
POST /wishlist/{userID}/{productID} - Add to wishlist
DELETE /wishlist/{userID}/{productID} - Remove from wishlist
```

## iOS Client Setup<br/>

### Prerequisites
Xcode 15+<br/>
iOS 16+<br/>

### Configuration

- Open the Client directory in Xcode<br/>
- Update the base URL in NetworkService.swift:<br/>
private let baseURL = "http://localhost:8080" // For simulator<br/>
// private let baseURL = "http://<your-local-ip>:8080" // For physical devices<br/>
- Build and run in simulator or device<br/>
- Database: MongoDB<br/>

### Development Assumptions

Single hardcoded user for simplicity (user123)
Products are pre-loaded into MongoDB
Development environment uses local MongoDB instance
iOS app targets latest stable iOS version
No authentication middleware for demo purposes

## Learning Process & Challenges

### Vapor/MongoDB Learning

### As a first-time Vapor and MongoDB user:

### Initial Setup:
Spent time understanding Vapor's async/await pattern
Learned MongoDB document structure

### Key Challenges:
- Adapting to MongoKitten's API changes between versions
- Ensuring Swift types matched MongoDB storage formats
- Error Handling: Implementing comprehensive error reporting
- Solutions:
    * Studied MongoKitten documentation and source code
    * Implemented extensive logging for debugging
    * Created sample data scripts to test cases

### Common Issues

- Connection Refused:
- Verify MongoDB container is running
- Check Docker logs: docker logs mongodb
- Authentication Failed:
- Confirm credentials in .env match Docker setup
- Recreate container if credentials were changed
- iOS Cannot Connect:
- Add App Transport Security exception in Info.plist

