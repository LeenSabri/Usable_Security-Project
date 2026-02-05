const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken, isEmployee } = require('../middleware/auth');

// Get all requests
router.get('/', verifyToken, async (req, res) => {
  try {
    let query = `
      SELECT r.*, 
             u.username, u.full_name, u.email,
             a.full_name as assigned_to_name
      FROM requests r
      INNER JOIN users u ON r.user_id = u.id
      LEFT JOIN users a ON r.assigned_to = a.id
      WHERE 1=1
    `;
    const params = [];

    // Customers see only their requests
    if (req.userRole === 'customer') {
      query += ' AND r.user_id = ?';
      params.push(req.userId);
    }
    // Employees see requests assigned to them
    else if (req.userRole === 'employee') {
      query += ' AND (r.assigned_to = ? OR r.assigned_to IS NULL)';
      params.push(req.userId);
    }

    query += ' ORDER BY r.created_at DESC';

    const [requests] = await db.query(query, params);

    res.json({ 
      success: true,
      count: requests.length,
      requests 
    });
  } catch (error) {
    console.error('Get requests error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching requests',
      error: error.message 
    });
  }
});

// Get request by ID
router.get('/:id', verifyToken, async (req, res) => {
  try {
    const [requests] = await db.query(
      `SELECT r.*, 
              u.username, u.full_name, u.email, u.phone,
              a.full_name as assigned_to_name
       FROM requests r
       INNER JOIN users u ON r.user_id = u.id
       LEFT JOIN users a ON r.assigned_to = a.id
       WHERE r.id = ?`,
      [req.params.id]
    );

    if (requests.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Request not found' 
      });
    }

    res.json({ 
      success: true,
      request: requests[0] 
    });
  } catch (error) {
    console.error('Get request error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching request',
      error: error.message 
    });
  }
});

// Create new request
router.post('/', verifyToken, async (req, res) => {
  try {
    const { type, subject, description, priority } = req.body;

    if (!type || !subject || !description) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide type, subject, and description' 
      });
    }

    const [result] = await db.query(
      `INSERT INTO requests (user_id, type, subject, description, priority) 
       VALUES (?, ?, ?, ?, ?)`,
      [req.userId, type, subject, description, priority || 'medium']
    );

    res.status(201).json({ 
      success: true,
      message: 'Request created successfully',
      requestId: result.insertId
    });
  } catch (error) {
    console.error('Create request error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error creating request',
      error: error.message 
    });
  }
});

// Assign request to employee
router.put('/:id/assign', verifyToken, isEmployee, async (req, res) => {
  try {
    const { employeeId } = req.body;

    const [result] = await db.query(
      'UPDATE requests SET assigned_to = ?, status = ? WHERE id = ?',
      [employeeId || req.userId, 'in_progress', req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Request not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Request assigned successfully' 
    });
  } catch (error) {
    console.error('Assign request error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error assigning request',
      error: error.message 
    });
  }
});

// Update request status
router.put('/:id/status', verifyToken, isEmployee, async (req, res) => {
  try {
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide status' 
      });
    }

    const resolvedAt = status === 'resolved' ? new Date() : null;

    const [result] = await db.query(
      'UPDATE requests SET status = ?, resolved_at = ? WHERE id = ?',
      [status, resolvedAt, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Request not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Request status updated successfully' 
    });
  } catch (error) {
    console.error('Update request error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error updating request',
      error: error.message 
    });
  }
});

// Delete request
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    // Check if user owns the request or is manager
    const [requests] = await db.query('SELECT user_id FROM requests WHERE id = ?', [req.params.id]);

    if (requests.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Request not found' 
      });
    }

    if (req.userRole === 'customer' && requests[0].user_id !== req.userId) {
      return res.status(403).json({ 
        success: false,
        message: 'Access denied' 
      });
    }

    await db.query('DELETE FROM requests WHERE id = ?', [req.params.id]);

    res.json({ 
      success: true,
      message: 'Request deleted successfully' 
    });
  } catch (error) {
    console.error('Delete request error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error deleting request',
      error: error.message 
    });
  }
});

module.exports = router;

