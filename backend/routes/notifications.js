const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken } = require('../middleware/auth');

// Get all notifications for user
router.get('/', verifyToken, async (req, res) => {
  try {
    const { isRead, type } = req.query;
    
    let query = 'SELECT * FROM notifications WHERE user_id = ?';
    const params = [req.userId];

    if (isRead !== undefined) {
      query += ' AND is_read = ?';
      params.push(isRead === 'true' ? 1 : 0);
    }

    if (type) {
      query += ' AND type = ?';
      params.push(type);
    }

    query += ' ORDER BY created_at DESC';

    const [notifications] = await db.query(query, params);

    res.json({ 
      success: true,
      count: notifications.length,
      notifications 
    });
  } catch (error) {
    console.error('Get notifications error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching notifications',
      error: error.message 
    });
  }
});

// Get unread notifications count
router.get('/unread/count', verifyToken, async (req, res) => {
  try {
    const [result] = await db.query(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = 0',
      [req.userId]
    );

    res.json({ 
      success: true,
      unreadCount: result[0].count 
    });
  } catch (error) {
    console.error('Get unread count error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching unread count',
      error: error.message 
    });
  }
});

// Mark notification as read
router.put('/:id/read', verifyToken, async (req, res) => {
  try {
    const [result] = await db.query(
      'UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?',
      [req.params.id, req.userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Notification not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Notification marked as read' 
    });
  } catch (error) {
    console.error('Mark as read error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error marking notification as read',
      error: error.message 
    });
  }
});

// Mark all notifications as read
router.put('/read-all', verifyToken, async (req, res) => {
  try {
    await db.query(
      'UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0',
      [req.userId]
    );

    res.json({ 
      success: true,
      message: 'All notifications marked as read' 
    });
  } catch (error) {
    console.error('Mark all as read error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error marking all notifications as read',
      error: error.message 
    });
  }
});

// Delete notification
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM notifications WHERE id = ? AND user_id = ?',
      [req.params.id, req.userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Notification not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Notification deleted successfully' 
    });
  } catch (error) {
    console.error('Delete notification error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error deleting notification',
      error: error.message 
    });
  }
});

// Create notification (for testing or system use)
router.post('/', verifyToken, async (req, res) => {
  try {
    const { userId, title, message, type, link } = req.body;

    if (!title || !message) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide title and message' 
      });
    }

    const [result] = await db.query(
      'INSERT INTO notifications (user_id, title, message, type, link) VALUES (?, ?, ?, ?, ?)',
      [userId || req.userId, title, message, type || 'system', link]
    );

    res.status(201).json({ 
      success: true,
      message: 'Notification created successfully',
      notificationId: result.insertId
    });
  } catch (error) {
    console.error('Create notification error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error creating notification',
      error: error.message 
    });
  }
});

module.exports = router;

