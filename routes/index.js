var atob, express, nodemailer, router;

express = require('express');

nodemailer = require('nodemailer');

atob = require('atob');

router = express.Router();


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
