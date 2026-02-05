const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const db = require('../config/database');
const { verifyToken, isManager } = require('../middleware/auth');

// Get all employees
router.get('/', verifyToken, isManager, async (req, res) => {
  try {
    const [employees] = await db.query(
      `SELECT id, username, email, full_name, phone, role, 
              profile_image, created_at
       FROM users 
       WHERE role IN ('employee', 'manager')
       ORDER BY created_at DESC`
    );

    res.json({ 
      success: true,
      count: employees.length,
      employees 
    });
  } catch (error) {
    console.error('Get employees error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching employees',
      error: error.message 
    });
  }
});

// Get employee by ID
router.get('/:id', verifyToken, isManager, async (req, res) => {
  try {
    const [employees] = await db.query(
      `SELECT id, username, email, full_name, phone, role, 
              profile_image, address, created_at
       FROM users 
       WHERE id = ? AND role IN ('employee', 'manager')`,
      [req.params.id]
    );

    if (employees.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Employee not found' 
      });
    }

    res.json({ 
      success: true,
      employee: employees[0] 
    });
  } catch (error) {
    console.error('Get employee error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching employee',
      error: error.message 
    });
  }
});

// Create new employee
router.post('/', verifyToken, isManager, async (req, res) => {
  try {
    const { username, email, password, fullName, phone, role, address } = req.body;

    if (!username || !email || !password || !fullName) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide all required fields' 
      });
    }

    // Validate role
    if (role && !['employee', 'manager'].includes(role)) {
      return res.status(400).json({ 
        success: false,
        message: 'Invalid role. Must be employee or manager' 
      });
    }

    // Check if user already exists
    const [existingUsers] = await db.query(
      'SELECT * FROM users WHERE username = ? OR email = ?',
      [username, email]
    );

    if (existingUsers.length > 0) {
      return res.status(400).json({ 
        success: false,
        message: 'Username or email already exists' 
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert new employee
    const [result] = await db.query(
      `INSERT INTO users (username, email, password, full_name, phone, role, address) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [username, email, hashedPassword, fullName, phone, role || 'employee', address]
    );

    res.status(201).json({ 
      success: true,
      message: 'Employee created successfully',
      employeeId: result.insertId
    });
  } catch (error) {
    console.error('Create employee error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error creating employee',
      error: error.message 
    });
  }
});

// Update employee
router.put('/:id', verifyToken, isManager, async (req, res) => {
  try {
    const { fullName, phone, address, role } = req.body;

    // Validate role if provided
    if (role && !['employee', 'manager'].includes(role)) {
      return res.status(400).json({ 
        success: false,
        message: 'Invalid role. Must be employee or manager' 
      });
    }

    const [result] = await db.query(
      `UPDATE users SET 
       full_name = COALESCE(?, full_name),
       phone = COALESCE(?, phone),
       address = COALESCE(?, address),
       role = COALESCE(?, role)
       WHERE id = ? AND role IN ('employee', 'manager')`,
      [fullName, phone, address, role, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Employee not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Employee updated successfully' 
    });
  } catch (error) {
    console.error('Update employee error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error updating employee',
      error: error.message 
    });
  }
});

// Delete employee
router.delete('/:id', verifyToken, isManager, async (req, res) => {
  try {
    // Prevent deleting self
    if (parseInt(req.params.id) === req.userId) {
      return res.status(400).json({ 
        success: false,
        message: 'Cannot delete your own account' 
      });
    }

    const [result] = await db.query(
      'DELETE FROM users WHERE id = ? AND role IN (\'employee\', \'manager\')',
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Employee not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Employee deleted successfully' 
    });
  } catch (error) {
    console.error('Delete employee error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error deleting employee',
      error: error.message 
    });
  }
});

// Get employee statistics
router.get('/:id/statistics', verifyToken, isManager, async (req, res) => {
  try {
    // Get delivery count
    const [deliveries] = await db.query(
      'SELECT COUNT(*) as total, status FROM deliveries WHERE employee_id = ? GROUP BY status',
      [req.params.id]
    );

    // Get assigned requests count
    const [requests] = await db.query(
      'SELECT COUNT(*) as total, status FROM requests WHERE assigned_to = ? GROUP BY status',
      [req.params.id]
    );

    res.json({ 
      success: true,
      statistics: {
        deliveries,
        requests
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

