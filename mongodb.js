var db, mongoose;

mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/test');

db = mongoose.connection;

db.on('error', function(err) {
  if (err) {
    return console.log(err);
  }
});

module.exports = db;
