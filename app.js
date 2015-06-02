var User, app, bodyParser, cookieParser, express, favicon, logger, path, requireLogin, routes, sessions;

express = require('express');

path = require('path');

favicon = require('serve-favicon');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

routes = {
  index: require('./routes/index'),
  users: require('./routes/users')
};

sessions = require('client-sessions');

User = require('./models/user');

app = express();

app.set('views', path.join(__dirname, 'views'));

app.set('view engine', 'jade');

app.use(logger('dev'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use(express["static"](path.join(__dirname, 'public')));

app.use(sessions({
  cookieName: 'myapp-session-daeyoungsite',
  requestKey: 'session',
  secret: 'a',
  duration: 24 * 60 * 60 * 1000,
  activeDuration: 1000 * 60 * 5,
  cookie: {
    domain: 'lvh.me',
    ephemeral: true,
    httpOnly: true,
    secure: false
  }
}));

app.use(function(req, res, next) {
  console.log('>>>>>>>>>>>>>>>>>>', req.session);
  res.locals.success = req.session.success;
  res.locals.error = req.session.error;
  res.locals.session = req.session || {};
  delete req.session.success;
  delete req.session.error;
  return next();
});

requireLogin = function(req, res, next) {
  if (!req.session.user) {
    req.session.error = 'auth required';
    return res.redirect('/login');
  }
  return next();
};

app.get('/', [requireLogin], function(req, res) {
  return res.render('index.jade', {
    title: 'MAIN !!'
  });
});

app.use('/', routes.index);

app.use('/users', routes.users);

app.use(function(req, res, next) {
  var err;
  err = new Error('Not Found');
  err.status = 404;
  return next(err);
});

if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    console.error(err);
    res.status(err.status || 500);
    return res.render('error', {
      message: err.message,
      error: err
    });
  });
}

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  return res.render('error', {
    message: err.message,
    error: {}
  });
});

module.exports = app;
