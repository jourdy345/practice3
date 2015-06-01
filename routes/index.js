var User, atob, db, express, nodemailer, router;

express = require('express');

router = express.Router();

nodemailer = require('nodemailer');

atob = require('atob');

db = require('../mongodb');

User = require('../models/user');


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

router.get('/login', function(req, res) {
  return User.find({}, function(err, result) {
    if (err) {
      console.log(err);
    }
    console.log('user:' + result);
    return res.render('login.jade');
  });
});

router.post('/login', function(req, res) {
  return User.findOne({
    userID: req.body.user_id
  }, function(err, user) {
    if (err) {
      console.log(err);
    }
    if (user === null) {
      req.session.error = 'login failed: no username';
      return res.redirect('/login');
    }
    if (user.password !== req.body.user_password) {
      req.session.error = 'login failed: invalid password';
      return res.redirect('/login');
    }
    console.log('logged in!');
    req.session.user = user;
    return res.redirect('/');
  });
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

module.exports = router;
