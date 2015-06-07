var User, mongoose;

mongoose = require('mongoose');

User = mongoose.model('Article', {
  userID: {
    type: String,
    required: true
  },
  password: {
    type: String,
    required: true
  }
});

module.exports = User;
