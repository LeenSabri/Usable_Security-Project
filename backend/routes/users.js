const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const db = require('../config/database');
const { verifyToken } = require('../middleware/auth');

// Get user profile
router.get('/profile', verifyToken, async (req, res) => {
  try {
    const [users] = await db.query(
      `SELECT id, username, email, full_name, phone, address, role, 
              profile_image, created_at 
       FROM users WHERE id = ?`,
      [req.userId]
    );

    if (users.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'User not found' 
      });
    }

    res.json({ 
      success: true,
      user: users[0] 
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching profile',
      error: error.message 
    });
  }
});

// Update user profile
router.put('/profile', verifyToken, async (req, res) => {
  try {
    const { fullName, phone, address, email } = req.body;

    // If email is being updated, check if it's already taken
    if (email) {
      const [existing] = await db.query(
        'SELECT id FROM users WHERE email = ? AND id != ?',
        [email, req.userId]
      );
      
      if (existing.length > 0) {
        return res.status(400).json({ 
          success: false,
          message: 'Email already in use' 
        });
      }
    }

    const [result] = await db.query(
      `UPDATE users SET 
       full_name = COALESCE(?, full_name),
       phone = COALESCE(?, phone),
       address = COALESCE(?, address),
       email = COALESCE(?, email)
       WHERE id = ?`,
      [fullName, phone, address, email, req.userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'User not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Profile updated successfully' 
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error updating profile',
      error: error.message 
    });
  }
});

// Change password
router.put('/change-password', verifyToken, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide current and new password' 
      });
    }

    // Get current user
    const [users] = await db.query('SELECT password FROM users WHERE id = ?', [req.userId]);
    
    if (users.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'User not found' 
      });
    }

    // Verify current password
    const passwordIsValid = await bcrypt.compare(currentPassword, users[0].password);

    if (!passwordIsValid) {
      return res.status(401).json({ 
        success: false,
        message: 'Current password is incorrect' 
      });
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update password
    await db.query('UPDATE users SET password = ? WHERE id = ?', [hashedPassword, req.userId]);

    res.json({ 
      success: true,
      message: 'Password changed successfully' 
    });
  } catch (error) {
    console.error('Change password error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error changing password',
      error: error.message 
    });
  }
});

// Get user statistics
router.get('/statistics', verifyToken, async (req, res) => {
  try {
    // Get bookings count
    const [bookings] = await db.query(
      'SELECT COUNT(*) as total, status FROM bookings WHERE user_id = ? GROUP BY status',
      [req.userId]
    );

    // Get requests count
    const [requests] = await db.query(
      'SELECT COUNT(*) as total, status FROM requests WHERE user_id = ? GROUP BY status',
      [req.userId]
    );

    // Get favorites count
    const [favorites] = await db.query(
      'SELECT COUNT(*) as total FROM favorites WHERE user_id = ?',
      [req.userId]
    );

    res.json({ 
      success: true,
      statistics: {
        bookings,
        requests,
        favoritesCount: favorites[0].total
      }
    });
  } catch (error) {
    console.error('Get statistics error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching statistics',
      error: error.message 
    });
  }
});

module.exports = router;

