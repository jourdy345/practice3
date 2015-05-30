express = require 'express'
nodemailer = require 'nodemailer'
atob = require 'atob'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
mongoose = require 'mongoose'
router = express.Router()

User = mongoose.model 'User', 
  userID:
    type: String
    required: true
  password:
    type: String
    required: true

User.schema.path('password').validate (value) ->
  if /

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

module.exports = router


## getting login requests and creating user sessions
router.get '/login', (req, res) ->
  User.find {}, (err, result) ->
    console.log err if err
    console.log 'user:' + result
    res.render 'login.jade'

passport.use(new LocalStrategy (username, password, done) ->
    User.findOne username: username, (err, user) ->
      if err then return done(err)
      if !user
        return done null, false,
          message: 'Incorrect username.'
      if !user.validPassword(password)
        return done null, false,
          message: 'Incorrect password.'
      return done null, user
)

router.post '/login',
  passport.authenticate 'local',
    successRedirect: '/'
    successFlash: 'Welcome!'
    failureRedirect: 'login'
    failureFlash: 'Invalid username or password'

## Mongo DB
mongoose.connect 'mongodb://localhost/test'

db = mongoose.connection
db.on 'error', (err) ->
  console.log err if err

router.post '/signup', (req, res) ->
  console.log req.body
  user1 = new User
    userID: req.body.user_id
    password: req.body.user_password

  user1.save (err) ->
    console.log err if err
    res.redirect '/login'







# 비밀번호 데이터 타입이 세 가지 이상일 것을 요구할 것
# 사용자 세션 만들 것














