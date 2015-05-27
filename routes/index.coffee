express = require 'express'
nodemailer = require 'nodemailer'
atob = require 'atob'
router = express.Router()

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
