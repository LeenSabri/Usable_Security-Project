const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken, isManager } = require('../middleware/auth');

// Get all feedback
router.get('/', verifyToken, isManager, async (req, res) => {
  try {
    const [feedbacks] = await db.query(
      `SELECT f.*, 
              u.username, u.full_name,
              b.id as booking_id, 
              c.name as car_name
       FROM feedback f
       INNER JOIN users u ON f.user_id = u.id
       LEFT JOIN bookings b ON f.booking_id = b.id
       LEFT JOIN cars c ON b.car_id = c.id
       ORDER BY f.created_at DESC`
    );

    res.json({ 
      success: true,
      count: feedbacks.length,
      feedbacks 
    });
  } catch (error) {
    console.error('Get feedbacks error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching feedbacks',
      error: error.message 
    });
  }
});

// Get user's feedback
router.get('/my-feedback', verifyToken, async (req, res) => {
  try {
    const [feedbacks] = await db.query(
      `SELECT f.*, 
              b.id as booking_id, 
              c.name as car_name
       FROM feedback f
       LEFT JOIN bookings b ON f.booking_id = b.id
       LEFT JOIN cars c ON b.car_id = c.id
       WHERE f.user_id = ?
       ORDER BY f.created_at DESC`,
      [req.userId]
    );

    res.json({ 
      success: true,
      count: feedbacks.length,
      feedbacks 
    });
  } catch (error) {
    console.error('Get my feedback error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching feedback',
      error: error.message 
    });
  }
});

// Submit feedback
router.post('/', verifyToken, async (req, res) => {
  try {
    const { bookingId, rating, comment } = req.body;

    if (!rating) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide rating' 
      });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({ 
        success: false,
        message: 'Rating must be between 1 and 5' 
      });
    }

    // If bookingId provided, verify it belongs to user
    if (bookingId) {
      const [bookings] = await db.query(
        'SELECT id FROM bookings WHERE id = ? AND user_id = ?',
        [bookingId, req.userId]
      );

      if (bookings.length === 0) {
        return res.status(404).json({ 
          success: false,
          message: 'Booking not found or access denied' 
        });
      }
    }

    const [result] = await db.query(
      'INSERT INTO feedback (user_id, booking_id, rating, comment) VALUES (?, ?, ?, ?)',
      [req.userId, bookingId || null, rating, comment]
    );

    res.status(201).json({ 
      success: true,
      message: 'Feedback submitted successfully',
      feedbackId: result.insertId
    });
  } catch (error) {
    console.error('Submit feedback error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error submitting feedback',
      error: error.message 
    });
  }
});

// Get average rating
router.get('/average-rating', async (req, res) => {
  try {
    const [result] = await db.query(
      'SELECT AVG(rating) as average, COUNT(*) as total FROM feedback'
    );

    res.json({ 
      success: true,
      averageRating: parseFloat(result[0].average || 0).toFixed(1),
      totalFeedbacks: result[0].total
    });
  } catch (error) {
    console.error('Get average rating error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching average rating',
      error: error.message 
    });
  }
});

module.exports = router;

