const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken, isEmployee } = require('../middleware/auth');

// Get all deliveries
router.get('/', verifyToken, async (req, res) => {
  try {
    let query = `
      SELECT d.*, 
             b.id as booking_id, b.user_id,
             c.name as car_name, c.brand, c.model,
             u.full_name as user_name,
             e.full_name as employee_name
      FROM deliveries d
      INNER JOIN bookings b ON d.booking_id = b.id
      INNER JOIN cars c ON b.car_id = c.id
      INNER JOIN users u ON b.user_id = u.id
      LEFT JOIN users e ON d.employee_id = e.id
      WHERE 1=1
    `;
    const params = [];

    // Employees see only their deliveries
    if (req.userRole === 'employee') {
      query += ' AND d.employee_id = ?';
      params.push(req.userId);
    }
    // Customers see only their deliveries
    else if (req.userRole === 'customer') {
      query += ' AND b.user_id = ?';
      params.push(req.userId);
    }

    query += ' ORDER BY d.scheduled_date DESC';

    const [deliveries] = await db.query(query, params);

    res.json({ 
      success: true,
      count: deliveries.length,
      deliveries 
    });
  } catch (error) {
    console.error('Get deliveries error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching deliveries',
      error: error.message 
    });
  }
});

// Get delivery by ID
router.get('/:id', verifyToken, async (req, res) => {
  try {
    const [deliveries] = await db.query(
      `SELECT d.*, 
              b.id as booking_id, b.user_id,
              c.name as car_name, c.brand, c.model,
              u.full_name as user_name, u.phone as user_phone,
              e.full_name as employee_name
       FROM deliveries d
       INNER JOIN bookings b ON d.booking_id = b.id
       INNER JOIN cars c ON b.car_id = c.id
       INNER JOIN users u ON b.user_id = u.id
       LEFT JOIN users e ON d.employee_id = e.id
       WHERE d.id = ?`,
      [req.params.id]
    );

    if (deliveries.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Delivery not found' 
      });
    }

    res.json({ 
      success: true,
      delivery: deliveries[0] 
    });
  } catch (error) {
    console.error('Get delivery error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching delivery',
      error: error.message 
    });
  }
});

// Create delivery
router.post('/', verifyToken, isEmployee, async (req, res) => {
  try {
    const { 
      bookingId, deliveryType, scheduledDate, location, 
      locationLat, locationLon, notes 
    } = req.body;

    if (!bookingId || !deliveryType || !scheduledDate) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide booking, delivery type, and scheduled date' 
      });
    }

    const [result] = await db.query(
      `INSERT INTO deliveries (
        booking_id, delivery_type, scheduled_date, location,
        location_lat, location_lon, notes
      ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [bookingId, deliveryType, scheduledDate, location, locationLat, locationLon, notes]
    );

    res.status(201).json({ 
      success: true,
      message: 'Delivery created successfully',
      deliveryId: result.insertId
    });
  } catch (error) {
    console.error('Create delivery error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error creating delivery',
      error: error.message 
    });
  }
});

// Assign employee to delivery
router.put('/:id/assign', verifyToken, isEmployee, async (req, res) => {
  try {
    const { employeeId } = req.body;

    const [result] = await db.query(
      'UPDATE deliveries SET employee_id = ?, status = ? WHERE id = ?',
      [employeeId || req.userId, 'in_progress', req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Delivery not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Delivery assigned successfully' 
    });
  } catch (error) {
    console.error('Assign delivery error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error assigning delivery',
      error: error.message 
    });
  }
});

// Update delivery status
router.put('/:id/status', verifyToken, isEmployee, async (req, res) => {
  try {
    const { status, actualDate } = req.body;

    if (!status) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide status' 
      });
    }

    const [result] = await db.query(
      'UPDATE deliveries SET status = ?, actual_date = ? WHERE id = ?',
      [status, actualDate || null, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Delivery not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Delivery status updated successfully' 
    });
  } catch (error) {
    console.error('Update delivery error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error updating delivery',
      error: error.message 
    });
  }
});

module.exports = router;

