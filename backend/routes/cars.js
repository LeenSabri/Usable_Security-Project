const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken, isManager } = require('../middleware/auth');

// Get all cars
router.get('/', async (req, res) => {
  try {
    const { status, brand, minPrice, maxPrice } = req.query;
    
    let query = 'SELECT * FROM cars WHERE 1=1';
    const params = [];

    if (status) {
      query += ' AND status = ?';
      params.push(status);
    }
    if (brand) {
      query += ' AND brand = ?';
      params.push(brand);
    }
    if (minPrice) {
      query += ' AND price_per_day >= ?';
      params.push(minPrice);
    }
    if (maxPrice) {
      query += ' AND price_per_day <= ?';
      params.push(maxPrice);
    }

    query += ' ORDER BY created_at DESC';

    const [cars] = await db.query(query, params);

    res.json({ 
      success: true,
      count: cars.length,
      cars 
    });
  } catch (error) {
    console.error('Get cars error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching cars',
      error: error.message 
    });
  }
});

// Get car by ID
router.get('/:id', async (req, res) => {
  try {
    const [cars] = await db.query('SELECT * FROM cars WHERE id = ?', [req.params.id]);

    if (cars.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Car not found' 
      });
    }

    res.json({ 
      success: true,
      car: cars[0] 
    });
  } catch (error) {
    console.error('Get car error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching car',
      error: error.message 
    });
  }
});

// Add new car (Manager only)
router.post('/', verifyToken, isManager, async (req, res) => {
  try {
    const { 
      name, brand, model, year, color, pricePerDay, 
      description, plateNumber, seats, transmission, fuelType 
    } = req.body;

    if (!name || !brand || !model || !year || !pricePerDay) {
      return res.status(400).json({ 
        success: false,
        message: 'Please provide all required fields' 
      });
    }

    const [result] = await db.query(
      `INSERT INTO cars (name, brand, model, year, color, price_per_day, 
       description, plate_number, seats, transmission, fuel_type) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [name, brand, model, year, color, pricePerDay, description, 
       plateNumber, seats, transmission, fuelType]
    );

    res.status(201).json({ 
      success: true,
      message: 'Car added successfully',
      carId: result.insertId
    });
  } catch (error) {
    console.error('Add car error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error adding car',
      error: error.message 
    });
  }
});

// Update car (Manager only)
router.put('/:id', verifyToken, isManager, async (req, res) => {
  try {
    const { 
      name, brand, model, year, color, pricePerDay, 
      description, plateNumber, seats, transmission, fuelType, status 
    } = req.body;

    const [result] = await db.query(
      `UPDATE cars SET 
       name = COALESCE(?, name),
       brand = COALESCE(?, brand),
       model = COALESCE(?, model),
       year = COALESCE(?, year),
       color = COALESCE(?, color),
       price_per_day = COALESCE(?, price_per_day),
       description = COALESCE(?, description),
       plate_number = COALESCE(?, plate_number),
       seats = COALESCE(?, seats),
       transmission = COALESCE(?, transmission),
       fuel_type = COALESCE(?, fuel_type),
       status = COALESCE(?, status)
       WHERE id = ?`,
      [name, brand, model, year, color, pricePerDay, description, 
       plateNumber, seats, transmission, fuelType, status, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Car not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Car updated successfully' 
    });
  } catch (error) {
    console.error('Update car error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error updating car',
      error: error.message 
    });
  }
});

// Delete car (Manager only)
router.delete('/:id', verifyToken, isManager, async (req, res) => {
  try {
    const [result] = await db.query('DELETE FROM cars WHERE id = ?', [req.params.id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Car not found' 
      });
    }

    res.json({ 
      success: true,
      message: 'Car deleted successfully' 
    });
  } catch (error) {
    console.error('Delete car error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error deleting car',
      error: error.message 
    });
  }
});

// Get user's favorite cars
router.get('/favorites/list', verifyToken, async (req, res) => {
  try {
    const [favorites] = await db.query(
      `SELECT c.* FROM cars c
       INNER JOIN favorites f ON c.id = f.car_id
       WHERE f.user_id = ?`,
      [req.userId]
    );

    res.json({ 
      success: true,
      count: favorites.length,
      favorites 
    });
  } catch (error) {
    console.error('Get favorites error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error fetching favorites',
      error: error.message 
    });
  }
});

// Add car to favorites
router.post('/favorites/:carId', verifyToken, async (req, res) => {
  try {
    const { carId } = req.params;

    // Check if car exists
    const [cars] = await db.query('SELECT id FROM cars WHERE id = ?', [carId]);
    if (cars.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Car not found' 
      });
    }

    // Add to favorites
    await db.query(
      'INSERT IGNORE INTO favorites (user_id, car_id) VALUES (?, ?)',
      [req.userId, carId]
    );

    res.json({ 
      success: true,
      message: 'Car added to favorites' 
    });
  } catch (error) {
    console.error('Add favorite error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error adding favorite',
      error: error.message 
    });
  }
});

// Remove car from favorites
router.delete('/favorites/:carId', verifyToken, async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM favorites WHERE user_id = ? AND car_id = ?',
      [req.userId, req.params.carId]
    );

    res.json({ 
      success: true,
      message: 'Car removed from favorites' 
    });
  } catch (error) {
    console.error('Remove favorite error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Error removing favorite',
      error: error.message 
    });
  }
});

module.exports = router;

