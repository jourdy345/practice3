var LocalStrategy, User, atob, db, express, mongoose, nodemailer, passport, router;

express = require('express');

nodemailer = require('nodemailer');

atob = require('atob');

passport = require('passport');

LocalStrategy = require('passport-local').Strategy;

mongoose = require('mongoose');

router = express.Router();

User = mongoose.model('User', {
  userID: {
    type: String,
    required: true
  },
  password: {
    type: String,
    required: true
  }
});


/*
GET home page.
 */

router.get('/', function(req, res, next) {
  return res.render('index.jade', {
    title: ''
  });
});

router.get('/about', function(req, res) {
  return res.render('about.jade');
});

router.get('/work', function(req, res) {
  return res.render('work.jade');
});

router.get('/life', function(req, res) {
  return res.render('life.jade');
});

router.get('/contact', function(req, res) {
  return res.render('contact.jade');
});

router.post('/contact', function(req, res) {
  var mailOptions, transporter;
  transporter = nodemailer.createTransport({
    service: 'iCloud',
    auth: {
      user: 'jourdy345@me.com',
      pass: '...'
    }
  });
  mailOptions = {
    from: req.body.email,
    to: "jourdy345@gmail.com",
    subject: req.body.title,
    text: req.body.body
  };
  return transporter.sendMail(mailOptions, function(error, info) {
    if (error) {
      console.log(error);
      return res.redirect('/contact/failed');
    }
    console.log("Message sent: " + info.response);
    return res.redirect('/contact/done');
  });
});

router.get('/contact/done', function(req, res) {
  return res.send('Sent !');
});

router.get('/contact/failed', function(req, res) {
  return res.send('Failed to send :/');
});

module.exports = router;

router.get('/login', function(req, res) {
  return User.find({}, function(err, result) {
    if (err) {
      console.log(err);
    }
    console.log('user:' + result);
    return res.render('login.jade');
  });
});

passport.use(new LocalStrategy(function(username, password, done) {
  return User.findOne({
    username: username
  }, function(err, user) {
    if (err) {
      return done(err);
    }
    if (!user) {
      return done(null, false, {
        message: 'Incorrect username.'
      });
    }
    if (!user.validPassword(password)) {
      return done(null, false, {
        message: 'Incorrect password.'
      });
    }
    return done(null, user);
  });
}));

router.post('/login', passport.authenticate('local', {
  successRedirect: '/',
  successFlash: 'Welcome!',
  failureRedirect: 'login',
  failureFlash: 'Invalid username or password'
}));

mongoose.connect('mongodb://localhost/test');

db = mongoose.connection;

db.on('error', function(err) {
  if (err) {
    return console.log(err);
  }
});

router.post('/signup', function(req, res) {
  var user1;
  console.log(req.body);
  user1 = new User({
    userID: req.body.user_id,
    password: req.body.user_password
  });
  return user1.save(function(err) {
    if (err) {
      console.log(err);
    }
    return res.redirect('/login');
  });
});
