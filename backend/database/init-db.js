const mysql = require('mysql2');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Create connection without database selection
const connection = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  port: process.env.DB_PORT || 3306,
  multipleStatements: true
});

console.log('🔄 Initializing database...');

connection.connect((err) => {
  if (err) {
    console.error('❌ Database connection error:', err.message);
    console.error('Please make sure MySQL is running!');
    process.exit(1);
  }

  console.log('✅ Connected to MySQL server');

  // Read and execute schema.sql
  const schemaPath = path.join(__dirname, 'schema.sql');
  const schema = fs.readFileSync(schemaPath, 'utf8');

  connection.query(schema, (err, results) => {
    if (err) {
      console.error('❌ Error creating database:', err.message);
      connection.end();
      process.exit(1);
    }

    console.log('✅ Database and tables created successfully');
    console.log('✅ Sample data inserted');
    console.log('');
    console.log('📊 Database: rentgo_db');
    console.log('👤 Default Admin:');
    console.log('   Username: admin');
    console.log('   Password: password');
    console.log('');

    connection.end();
    console.log('✅ Database initialization complete!');
  });
});

