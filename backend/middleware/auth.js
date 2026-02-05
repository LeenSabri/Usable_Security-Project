const jwt = require('jsonwebtoken');

// Verify JWT token
const verifyToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1] || req.headers['x-access-token'];

  if (!token) {
    return res.status(403).json({ 
      success: false,
      message: 'No token provided!' 
    });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ 
        success: false,
        message: 'Unauthorized! Invalid token.' 
      });
    }
    req.userId = decoded.id;
    req.userRole = decoded.role;
    next();
  });
};

// Check if user is manager
const isManager = (req, res, next) => {
  if (req.userRole !== 'manager') {
    return res.status(403).json({ 
      success: false,
      message: 'Require Manager Role!' 
    });
  }
  next();
};

// Check if user is employee or manager
const isEmployee = (req, res, next) => {
  if (req.userRole !== 'employee' && req.userRole !== 'manager') {
    return res.status(403).json({ 
      success: false,
      message: 'Require Employee or Manager Role!' 
    });
  }
  next();
};

module.exports = {
  verifyToken,
  isManager,
  isEmployee
};

