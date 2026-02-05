# RentGo Backend API

Complete REST API for RentGo Car Rental Application built with Node.js, Express, and MySQL.

## 🚀 Features

- **Authentication**: Login, Signup with JWT tokens
- **Cars Management**: CRUD operations for cars, favorites
- **Bookings**: Create and manage car bookings
- **Deliveries**: Track car pickup and return deliveries
- **Requests**: Handle customer support requests
- **Employees**: Manage employee accounts (Manager only)
- **Notifications**: Real-time user notifications
- **Feedback**: Customer ratings and reviews

## 📋 Prerequisites

Before running this application, make sure you have:

- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **MySQL** (v5.7 or higher) - [Download](https://dev.mysql.com/downloads/)
- **npm** or **yarn** package manager

## 🛠️ Installation

### 1. Install Node.js Dependencies

```bash
cd backend
npm install
```

### 2. Configure Database

1. Make sure MySQL is running
2. Copy `.env.example` to `.env`:
   ```bash
   copy .env.example .env
   ```
3. Edit `.env` file and set your MySQL password:
   ```
   DB_PASSWORD=your_mysql_password
   ```

### 3. Initialize Database

```bash
npm run init-db
```

This will:
- Create `rentgo_db` database
- Create all necessary tables
- Insert sample data
- Create default admin account

## 🏃‍♂️ Running the Server

### Start the server:
```bash
npm start
```

### For development (with auto-reload):
```bash
npm run dev
```

The server will run on: **http://localhost:3000**

## 🔑 Default Login Credentials

**Admin Account:**
- Username: `admin`
- Password: `password`

## 📚 API Endpoints

### Authentication
- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login user

### Cars
- `GET /api/cars` - Get all cars
- `GET /api/cars/:id` - Get car by ID
- `POST /api/cars` - Add new car (Manager only)
- `PUT /api/cars/:id` - Update car (Manager only)
- `DELETE /api/cars/:id` - Delete car (Manager only)
- `GET /api/cars/favorites/list` - Get user favorites
- `POST /api/cars/favorites/:carId` - Add to favorites
- `DELETE /api/cars/favorites/:carId` - Remove from favorites

### Bookings
- `GET /api/bookings` - Get all bookings
- `GET /api/bookings/:id` - Get booking by ID
- `POST /api/bookings` - Create new booking
- `PUT /api/bookings/:id/status` - Update booking status
- `DELETE /api/bookings/:id` - Cancel booking
- `GET /api/bookings/history/user` - Get user booking history

### Deliveries
- `GET /api/deliveries` - Get all deliveries
- `GET /api/deliveries/:id` - Get delivery by ID
- `POST /api/deliveries` - Create delivery
- `PUT /api/deliveries/:id/assign` - Assign employee
- `PUT /api/deliveries/:id/status` - Update status

### Requests
- `GET /api/requests` - Get all requests
- `GET /api/requests/:id` - Get request by ID
- `POST /api/requests` - Create new request
- `PUT /api/requests/:id/assign` - Assign to employee
- `PUT /api/requests/:id/status` - Update status
- `DELETE /api/requests/:id` - Delete request

### Employees (Manager Only)
- `GET /api/employees` - Get all employees
- `GET /api/employees/:id` - Get employee by ID
- `POST /api/employees` - Create new employee
- `PUT /api/employees/:id` - Update employee
- `DELETE /api/employees/:id` - Delete employee
- `GET /api/employees/:id/statistics` - Get employee stats

### Notifications
- `GET /api/notifications` - Get user notifications
- `GET /api/notifications/unread/count` - Get unread count
- `PUT /api/notifications/:id/read` - Mark as read
- `PUT /api/notifications/read-all` - Mark all as read
- `DELETE /api/notifications/:id` - Delete notification

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile
- `PUT /api/users/change-password` - Change password
- `GET /api/users/statistics` - Get user statistics

### Feedback
- `GET /api/feedback` - Get all feedback (Manager only)
- `GET /api/feedback/my-feedback` - Get user's feedback
- `POST /api/feedback` - Submit feedback
- `GET /api/feedback/average-rating` - Get average rating

## 🔐 Authentication

Most endpoints require JWT token authentication. Include the token in request headers:

```
Authorization: Bearer <your_token>
```

## 📦 Database Schema

### Tables:
- **users** - User accounts (customers, employees, managers)
- **cars** - Available cars for rent
- **bookings** - Car rental bookings
- **deliveries** - Pickup and return deliveries
- **requests** - Customer support requests
- **favorites** - User favorite cars
- **notifications** - User notifications
- **feedback** - Customer reviews and ratings

## 🤝 Role-Based Access

- **Customer**: Can book cars, view their bookings, submit requests
- **Employee**: Can manage deliveries, handle requests
- **Manager**: Full access including employee management

## 📝 License

This project is for educational purposes.

---

**Built with ❤️ for RentGo**

