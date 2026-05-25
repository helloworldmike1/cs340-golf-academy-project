//Citation for the following function:
// Date: 05/25/2026
//Copied from /OR/ Adapted from /OR/ Based on: copied from the starter code.
// Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188





require("dotenv").config();
const mysql = require("mysql2");

const pool = mysql
  .createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
  })
  .promise();

module.exports = pool;
