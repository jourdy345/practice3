express = require 'express'
router = express.Router()
nodemailer = require 'nodemailer'
atob = require 'atob'
# passport = require 'passport'
# LocalStrategy = require('passport-local').Strategy
db = require '../mongodb'
User = require '../models/user'

# User.schema.path('password').validate (value) ->
#   if /

###
GET home page.
###
router.get '/', (req, res, next) ->
  res.render 'index.jade',
    title: ''

router.get '/about', (req, res) ->
  res.render 'about.jade'

router.get '/work', (req, res) ->
  res.render 'work.jade'

router.get '/life', (req, res) ->
  res.render 'life.jade'

router.get '/contact', (req, res) ->
  res.render 'contact.jade'


## /contact email delivering system code
router.post '/contact', (req, res) ->
  transporter = nodemailer.createTransport
    service: 'iCloud'
    auth:
      user: 'jourdy345@me.com'
      pass: '...'

  mailOptions = 
    from: req.body.email
    to: "jourdy345@gmail.com"
    subject: req.body.title
    text: req.body.body

  transporter.sendMail mailOptions, (error, info) ->
    if error
      console.log error
      return res.redirect '/contact/failed'
    console.log "Message sent: #{info.response}"
    res.redirect '/contact/done'
  # res.redirect '/contact/done'


router.get '/contact/done', (req, res) ->
  res.send 'Sent !'

router.get '/contact/failed', (req, res) ->
  res.send 'Failed to send :/'

## getting login requests and creating user sessions
router.get '/login', (req, res) ->
  User.find {}, (err, result) ->
    console.log err if err
    console.log 'user:' + result
    res.render 'login.jade'

# passport.use new LocalStrategy (user_id, user_password, done) ->
#   # find user(id: hello)
#   User.findOne userID: user_id, (err, user) ->
#     if err
#       return done err
#     # error if user == null
#     if user is null
#       return done null, false,
#         message: 'Incorrect username.'
#     # error if user password != user_password
#     if user.password isnt user_password
#       return done null, false,
#         message: 'Invalid password'
#     # return to create session
#     return done null, user

# passport.serializeUser (user, done) ->
#   done null, user._id

# passport.deserializeUser (_id, done) ->
#   User.findById _id, (err, user) ->
#     done err, user

# router.post '/signin',
#   passport.authenticate 'local',
#     successRedirect: '/'
#     successFlash: 'Welcome!'
#     failureRedirect: '/login'
#     failureFlash: 'Invalid username or password'


## Posting new user data to MongoDB
router.post '/signup', (req, res) ->
  console.log req.body
  user1 = new User
    userID: req.body.user_id
    password: req.body.user_password

  user1.save (err) ->
    console.log err if err
    res.redirect '/login'


## Creating User Sessions
# router.post '/signin', (req, res) ->
#   # find user(id: hello)
#   User.findOne userID: req.body.user_id, (err, user) ->
#     console.log err if err
#     if !user?
#       console.log 'Nonexistent User'
#     else req.session
#     res.redirect '/login'
    # if err
    #   console.log err

  # error if user == null
  # error if user password != user_password
  # return to create session


# express.use sessions 
#   cookieName: 'mySession'
#   secret: 'dwkobdkwdokDwokdjwSsldohkwedR'
#   duration: 24 * 60 * 60 * 1000
#   activeDuration: 1000 * 60 * 5
#   cookie:
#     maxAge: 60000
#     ephemeral: true
#     httpOnly: true
#     secure: false


# express.use (req, res, next) ->
#   res.locals.success = req.session.success
#   res.locals.error = req.session.error

#   if req.mySession.seenyou 
#     res.setHeader 'X-Seen-You', 'true'
#   ## setting a property will automatically cause a Set-Cookie response to be sent
#   req.mySession.seenyou = true
#   res.setHeader 'X-Seen-You', 'false'





## 로그인할 때 데이터베이스에 있는 ID인지 체크한 후 있으면 세션 생성


module.exports = router






