
mongoose = require 'mongoose'

## MongoDB
User = mongoose.model 'Article', 
  userID:
    type: String
    required: true
  password:
    type: String
    required: true

module.exports = User