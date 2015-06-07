MongoDB = require 'mongodb'
objectid = MongoDB.ObjectID
server = new MongoDB.Server 'localhost', 27017, auto_reconnect: true
db = new MongoDB.Db 'Users', server





# mongoose = require 'mongoose'

# ## Connecting with MongoDB
# mongoose.connect 'mongodb://localhost/test'

# db = mongoose.connection
# db.on 'error', (err) ->
#   console.log err if err


module.exports = db