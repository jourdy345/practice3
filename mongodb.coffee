mongoose = require 'mongoose'

## Connecting with MongoDB
mongoose.connect 'mongodb://localhost/test'

db = mongoose.connection
db.on 'error', (err) ->
  console.log err if err


module.exports = db