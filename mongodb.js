var MongoDB, db, objectid, server;

MongoDB = require('mongodb');

objectid = MongoDB.ObjectID;

server = new MongoDB.Server('localhost', 27017, {
  auto_reconnect: true
});

db = new MongoDB.Db('Users', server);

module.exports = db;
