const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
const authRoutes = require('./routes/auth');
const carRoutes = require('./routes/cars');
const bookingRoutes = require('./routes/bookings');
const deliveryRoutes = require('./routes/deliveries');
const requestRoutes = require('./routes/requests');
const employeeRoutes = require('./routes/employees');
const notificationRoutes = require('./routes/notifications');
const userRoutes = require('./routes/users');
const feedbackRoutes = require('./routes/feedback');

app.use('/api/auth', authRoutes);
app.use('/api/cars', carRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/deliveries', deliveryRoutes);
app.use('/api/requests', requestRoutes);
app.use('/api/employees', employeeRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/users', userRoutes);
app.use('/api/feedback', feedbackRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'RentGo Backend API is running',
    timestamp: new Date().toISOString()
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'Welcome to RentGo API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      cars: '/api/cars',
      bookings: '/api/bookings',
      deliveries: '/api/deliveries',
      requests: '/api/requests',
      employees: '/api/employees',
      notifications: '/api/notifications',
      users: '/api/users',
      feedback: '/api/feedback'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: err.message 
  });
});

// Start server
app.listen(PORT, () => {
  console.log('=================================');
  console.log(`🚀 RentGo Backend Server Running`);
  console.log(`📡 Port: ${PORT}`);
  console.log(`🌍 URL: http://localhost:${PORT}`);
  console.log(`📚 API Docs: http://localhost:${PORT}/`);
  console.log('=================================');
});

module.exports = app;

