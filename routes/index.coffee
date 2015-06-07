express = require 'express'
router = express.Router()
nodemailer = require 'nodemailer'
atob = require 'atob'
# passport = require 'passport'
# LocalStrategy = require('passport-local').Strategy
db = require '../mongodb'
assert = require 'assert'

ObjectID = require('mongodb').ObjectID
# User = require '../models/user'

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

router.get '/diary', (req, res) ->
  console.log '>>', req.session, res.locals
  db.open (err, db) ->
    console.log err if err
    db.collection 'Articles', (err, collection) ->
      console.log err if err
      collection.find 
        user_id: req.session.user._id
      .toArray (err, articles) ->
        console.log '>> ', articles
        db.close()
        res.render 'diary.jade', 
          articles: articles

router.get '/contact', (req, res) ->
  res.render 'contact.jade'

router.get '/writing', (req, res) ->
  res.render 'writing.jade'


router.get '/edit/:id', (req, res) ->
  db.open (err, db) ->
    console.log err if err
    db.collection 'Articles', (err, collection) ->
      console.log err if err
      console.log 'id: ', req.params.id
      collection.findOne
        _id: new ObjectID(req.params.id)
      , (err, article) ->
        console.log article
        db.close()
        res.render 'edit.jade',
          article: article


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
  if req.session.user
    req.session.error = 'Already logged in !'
    return res.redirect '/'
  db.open (err, db) ->
    console.log err if err
    db.collection 'Users', (err, collection) ->
      console.log err if err
      collection.find {}, (err, result) ->
        console.log err if err
        console.log 'user:' + result
        res.render 'login.jade'
        db.close()

router.get '/logout', (req, res) ->
  req.session = {}
  req.session.error = 'Logged out !'
  res.redirect '/'

## log-in system
router.post '/login', (req, res) ->
  db.open (err, db) ->
    console.log err if err
    db.collection 'Users', (err, collection) ->
      console.log err if err
      collection.findOne user_id: req.body.user_id, (err, user) ->
        console.log err if err
        if user is null
          req.session.error = 'login failed: no username'
          return res.redirect '/login'
        
        if user.user_password isnt req.body.user_password
          req.session.error = 'login failed: invalid password'
          return res.redirect '/login'
        
        console.log 'logged in!'
        req.session.user = user
        res.redirect '/'
        db.close()

# 1.  diary?.json  >> /diary
#                  >> /diary.json
#     if url.endsWith '.json'
#       ...
#     else
#       html

# 2. 

# content negotiation 

# A -> Accept: application/json
# B -> Accept: text/plain

# req.accepts('application/json') === true


# router.post '/diary.json', (req, res) ->
#   # console.log '>>'
#   # res.send 'Okay'
#   db.open (err, db) ->
#     console.log err if err
#     db.collection('Articles').insertOne
#       user_id: req.session.user._id
#       article: req.body.article
#       date: Date.now()
#     , (err, result) ->
#       console.log err if err
#       console.log result
#       # req.session.success = 'Article added !'
#       db.close()
#       res.send
#         _id: result.insertedId

router.post '/diary', (req, res) ->
  # console.log '>>'
  # res.send 'Okay'
  db.open (err, db) ->
    console.log err if err
    db.collection('Articles').insertOne
      user_id: req.session.user._id
      article: req.body.article
      date: Date.now()
    , (err, result) ->
      console.log err if err
      console.log result
      req.session.success = 'Article added !'
      db.close()
      if req.accepts('application/json') and not req.accepts('html')
        res.send
          _id: result.insertedId
          date: Date.now()
      else
        res.redirect '/diary'

router.post '/edit/:id', (req, res) ->
  db.open (err, db) ->
    console.log err if err
    db.collection('Articles').update 
      _id: new ObjectID(req.params.id)
    ,
      $set:
        article: req.body.article
        date: Date.now()
    , (err, result) ->
      console.log err if err
      console.log result
      console.log req.params.id
      db.close()
      res.redirect '/diary'

router.get '/delete/:id', (req, res) ->
  db.open (err, db) ->
    console.log err if err
    db.collection('Articles').remove 
      _id: new ObjectID(req.params.id)
    db.close()
    req.session.success = 'Successfully deleted !'
    res.redirect '/diary'

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
  db.open (err, db) ->
    console.log err if err
    db.collection('Users').insertOne
      user_id: req.body.user_id
      user_password: req.body.user_password
    , (err, result) ->
      assert.equal err, null
      console.log 'Inserted a document'
      db.close()
      res.redirect '/login'


  # user1 = new User
  #   userID: req.body.user_id
  #   password: req.body.user_password
  #   article: {}

  # user1.save (err) ->
  #   console.log err if err
  #   res.redirect '/login'

# router.post '/diary', (req, res) ->
#   console.log req.body
#   User.add article: 'string'
#   User.findById req.session.user._id, (err, user) ->
#     user.article: req.body.article
    
#   req.session.success = 'Article Saved !'
#   res.redirect '/diary'




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






