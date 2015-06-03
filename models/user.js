var User, mongoose;

mongoose = require('mongoose');

User = mongoose.model('User', {
  userID: {
    type: String,
    required: true
  },
  password: {
    type: String,
    required: true
  },
  article: {
    type: String,
    required: false
  }
});

module.exports = User;
