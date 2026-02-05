const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken, isEmployee } = require('../middleware/auth');

// Get all bookings (with filters)
router.get('/', verifyToken, async (req, res) => {
  try {
    const { status, userId, carId } = req.query;
    
    let query = `
      SELECT b.*, 
             u.username, u.full_name, u.email, u.phone as user_phone,
             c.name as car_name, c.brand, c.model
      FROM bookings b
      INNER JOIN users u ON b.user_id = u.id
      INNER JOIN cars c ON b.car_id = c.id
      WHERE 1=1
    `;
    const params = [];

    // Non-managers can only see their own bookings
    if (req.userRole === 'customer') {
      query += ' AND b.user_id = ?';
      params.push(req.userId);
    } else if (userId) {
      query += ' AND b.user_id = ?';
      params.push(userId);
    }

    if (status) {
      query += ' AND b.status = ?';
      params.push(status);
    }
    if (carId) {
      query += ' AND b.car_id = ?';
      params.push(carId);
    }

    query += ' ORDER BY b.created_at DESC';

    const [bookings] = await db.query(query, params);

    res.json({ 
      success: true,
      count: bookings.length,
      bookings 
    });
  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching bookings',
      error: error.message 
    });
  }
});

// Get booking by ID
router.get('/:id', verifyToken, async (req, res) => {
  try {
    const [bookings] = await db.query(
      `SELECT b.*, 
              u.username, u.full_name, u.email, u.phone as user_phone,
              c.name as car_name, c.brand, c.model, c.price_per_day
       FROM bookings b
       INNER JOIN users u ON b.user_id = u.id
       INNER JOIN cars c ON b.car_id = c.id
       WHERE b.id = ?`,
      [req.params.id]
    );

    if (bookings.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Booking not found' 
      });
    }

    const booking = bookings[0];

    // Check access rights
    if (req.userRole === 'customer' && booking.user_id !== req.userId) {
      return res.status(403).json({ 
        success: false,
        message: 'Access denied' 
      });
    }

    res.json({ 
      success: true,
      booking 
    });
  } catch (error) {
    console.error('Get booking error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching booking',
      error: error.message 
    });
  }
});

// Create new booking
router.post('/', verifyToken, async (req, res) => {
  try {
    const { 
      carId, startDate, endDate, pickupLocation, pickupLat, pickupLon,
      phone, paymentMethod, notes 
    } = req.body;

    if (!carId || !startDate || !endDate) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide car, start date, and end date' 
      });
    }

    // Get car details
    const [cars] = await db.query('SELECT * FROM cars WHERE id = ?', [carId]);
    if (cars.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Car not found' 
      });
    }

    const car = cars[0];

    // Check if car is available
    if (car.status !== 'available') {
      return res.status(400).json({ 
        success: false,
        message: 'Car is not available' 
      });
    }

    // Calculate total price
    const start = new Date(startDate);
    const end = new Date(endDate);
    const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
    const totalPrice = days * car.price_per_day;

    // Create booking
    const [result] = await db.query(
      `INSERT INTO bookings (
        user_id, car_id, start_date, end_date, pickup_location, 
        pickup_lat, pickup_lon, phone, payment_method, total_price, notes
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [req.userId, carId, startDate, endDate, pickupLocation, 
       pickupLat, pickupLon, phone, paymentMethod, totalPrice, notes]
    );

    // Update car status
    await db.query('UPDATE cars SET status = ? WHERE id = ?', ['rented', carId]);

    // Create notification
    await db.query(
      `INSERT INTO notifications (user_id, title, message, type) 
       VALUES (?, ?, ?, ?)`,
      [req.userId, 'Booking Confirmed', 
       `Your booking for ${car.name} has been created successfully!`, 'booking']
    );

    res.status(201).json({ 
      success: true,
      message: 'Booking created successfully',
      bookingId: result.insertId,
      totalPrice
    });
  } catch (error) {
    console.error('Create booking error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error creating booking',
      error: error.message 
    });
  }
});

// Update booking status (Employee/Manager)
router.put('/:id/status', verifyToken, isEmployee, async (req, res) => {
  try {
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide status' 
      });
    }

    const [result] = await db.query(
      'UPDATE bookings SET status = ? WHERE id = ?',
      [status, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Booking not found' 
      });
    }

    // If completed or cancelled, update car status
    if (status === 'completed' || status === 'cancelled') {
      const [bookings] = await db.query('SELECT car_id FROM bookings WHERE id = ?', [req.params.id]);
      if (bookings.length > 0) {
        await db.query('UPDATE cars SET status = ? WHERE id = ?', ['available', bookings[0].car_id]);
      }
    }

    res.json({ 
      success: true,
      message: 'Booking status updated successfully' 
    });
  } catch (error) {
    console.error('Update booking error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error updating booking',
      error: error.message 
    });
  }
});

// Cancel booking
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    const [bookings] = await db.query('SELECT * FROM bookings WHERE id = ?', [req.params.id]);

    if (bookings.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Booking not found' 
      });
    }

    const booking = bookings[0];

    // Check access rights
    if (req.userRole === 'customer' && booking.user_id !== req.userId) {
      return res.status(403).json({ 
        success: false,
        message: 'Access denied' 
      });
    }

    // Update booking status
    await db.query('UPDATE bookings SET status = ? WHERE id = ?', ['cancelled', req.params.id]);

    // Update car status
    await db.query('UPDATE cars SET status = ? WHERE id = ?', ['available', booking.car_id]);

    res.json({ 
      success: true,
      message: 'Booking cancelled successfully' 
    });
  } catch (error) {
    console.error('Cancel booking error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error cancelling booking',
      error: error.message 
    });
  }
});

// Get booking history for user
router.get('/history/user', verifyToken, async (req, res) => {
  try {
    const [bookings] = await db.query(
      `SELECT b.*, c.name as car_name, c.brand, c.model, c.image_url
       FROM bookings b
       INNER JOIN cars c ON b.car_id = c.id
       WHERE b.user_id = ? AND b.status IN ('completed', 'cancelled')
       ORDER BY b.created_at DESC`,
      [req.userId]
    );

    res.json({ 
      success: true,
      count: bookings.length,
      history: bookings 
    });
  } catch (error) {
    console.error('Get history error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching booking history',
      error: error.message 
    });
  }
});

module.exports = router;

