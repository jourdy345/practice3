var ObjectID, assert, atob, db, express, nodemailer, router;

express = require('express');

router = express.Router();

nodemailer = require('nodemailer');

atob = require('atob');

db = require('../mongodb');

assert = require('assert');

ObjectID = require('mongodb').ObjectID;


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

router.get('/diary', function(req, res) {
  console.log('>>', req.session, res.locals);
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Articles', function(err, collection) {
      if (err) {
        console.log(err);
      }
      return collection.find({
        user_id: req.session.user._id
      }).toArray(function(err, articles) {
        console.log('>> ', articles);
        db.close();
        return res.render('diary.jade', {
          articles: articles
        });
      });
    });
  });
});

router.get('/contact', function(req, res) {
  return res.render('contact.jade');
});

router.get('/writing', function(req, res) {
  return res.render('writing.jade');
});

router.get('/edit/:id', function(req, res) {
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Articles', function(err, collection) {
      if (err) {
        console.log(err);
      }
      console.log('id: ', req.params.id);
      return collection.findOne({
        _id: new ObjectID(req.params.id)
      }, function(err, article) {
        console.log(article);
        db.close();
        return res.render('edit.jade', {
          article: article
        });
      });
    });
  });
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
  if (req.session.user) {
    req.session.error = 'Already logged in !';
    return res.redirect('/');
  }
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Users', function(err, collection) {
      if (err) {
        console.log(err);
      }
      return collection.find({}, function(err, result) {
        if (err) {
          console.log(err);
        }
        console.log('user:' + result);
        res.render('login.jade');
        return db.close();
      });
    });
  });
});

router.get('/logout', function(req, res) {
  req.session = {};
  req.session.error = 'Logged out !';
  return res.redirect('/');
});

router.post('/login', function(req, res) {
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Users', function(err, collection) {
      if (err) {
        console.log(err);
      }
      return collection.findOne({
        user_id: req.body.user_id
      }, function(err, user) {
        if (err) {
          console.log(err);
        }
        if (user === null) {
          req.session.error = 'login failed: no username';
          return res.redirect('/login');
        }
        if (user.user_password !== req.body.user_password) {
          req.session.error = 'login failed: invalid password';
          return res.redirect('/login');
        }
        console.log('logged in!');
        req.session.user = user;
        res.redirect('/');
        return db.close();
      });
    });
  });
});

router.post('/diary', function(req, res) {
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Articles').insertOne({
      user_id: req.session.user._id,
      article: req.body.article,
      date: Date.now()
    }, function(err, result) {
      if (err) {
        console.log(err);
      }
      console.log(result);
      req.session.success = 'Article added !';
      db.close();
      if (req.accepts('application/json') && !req.accepts('html')) {
        return res.send({
          _id: result.insertedId,
          date: Date.now()
        });
      } else {
        return res.redirect('/diary');
      }
    });
  });
});

router.post('/edit/:id', function(req, res) {
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Articles').update({
      _id: new ObjectID(req.params.id)
    }, {
      $set: {
        article: req.body.article,
        date: Date.now()
      }
    }, function(err, result) {
      if (err) {
        console.log(err);
      }
      console.log(result);
      console.log(req.params.id);
      db.close();
      return res.redirect('/diary');
    });
  });
});

router.get('/delete/:id', function(req, res) {
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    db.collection('Articles').remove({
      _id: new ObjectID(req.params.id)
    });
    db.close();
    req.session.success = 'Successfully deleted !';
    return res.redirect('/diary');
  });
});

router.post('/signup', function(req, res) {
  console.log(req.body);
  return db.open(function(err, db) {
    if (err) {
      console.log(err);
    }
    return db.collection('Users').insertOne({
      user_id: req.body.user_id,
      user_password: req.body.user_password
    }, function(err, result) {
      assert.equal(err, null);
      console.log('Inserted a document');
      db.close();
      return res.redirect('/login');
    });
  });
});

module.exports = router;
