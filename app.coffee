express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
routes = 
  index: require './routes/index'
  users: require './routes/users'
sessions = require 'client-sessions'
User = require './models/user'
app = express()

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'))
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))


## session setup
app.use sessions 
  cookieName: 'myapp-session-daeyoungsite'
  requestKey: 'session'
  secret: 'a'
  duration: 24 * 60 * 60 * 1000
  activeDuration: 1000 * 60 * 5
  cookie:
    domain: 'lvh.me'
    # maxAge: 60000
    ephemeral: true
    ## You cannot have an ephemeral cookie with a set maxAge
    httpOnly: true
    secure: false

app.use (req, res, next) ->
  console.log '>>>>>>>>>>>>>>>>>>', req.session
  res.locals.user_success = req.session.success
  res.locals.user_error = req.session.error
  res.locals.session = req.session or {}
  delete req.session.success
  delete req.session.error
  next()


## global middleware checking if there's a session
app.use (req, res, next) ->
  if req.session and req.session.user 
    User.findOne userID: req.session.user, (err, user) ->
      if user
        req.user = user
        delete req.user.password
        req.session.user = user
        res.locals.user = user
      next()
  else next()

## A middleware function that will check if the user is logged in and redirect them if not.
requireLogin = (req, res, next) ->
  if !req.user
    return res.redirect '/login'
  next()





  # if req.session.username
  #   res.send 'Welcome #{req.session_state.username}!'
  # res.send 'You need to logout'

app.use('/', routes.index)
app.use('/users', routes.users)

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next(err)


# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
  app.use (err, req, res, next) ->
    console.error err
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}


module.exports = app