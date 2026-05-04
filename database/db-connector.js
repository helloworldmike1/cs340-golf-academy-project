const mysql = require('mysql2');

const pool = mysql
  .createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: 'classmysql.engr.oregonstate.edu',
    user: 'cs340_pearsalm',
    password: 'TXZccdOASoAh',
    database: 'cs340_pearsalm'
  })
  .promise();

module.exports = pool;