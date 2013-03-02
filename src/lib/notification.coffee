
nodemailer = require 'nodemailer'
TwilioAPI = require('twilio-api').Client

class Notification extends Base

  email: (subject, message) ->

    ### Send an e-mail using a Gmail account. ###

    @emit 'monitor:notification:email', subject, message

    try 
      user = @config['notification:gmail:username']
      pass = @config['notification:gmail:password']
      to = @config['notification:email:to']
    catch err
      @err @errors.NOT_CONFIGURED_CORRECTLY, err
      return

    # Create reusable transport method (opens pool of SMTP connections).
    smtpTransport = nodemailer.createTransport('SMTP',
      service: 'Gmail'
      auth:
        user: user
        pass: pass
    )

    # Setup e-mail data with unicode symbols.
    options =
      from: 'node-monitor ✔ <no-reply@node-monitor.com>'
      to: to # Comma-delimited list.
      subject: subject
      html: message

    # Send e-mail with defined transport object.
    smtpTransport.sendMail options, (err, resp) ->
      if err
        @err @errors.NOTIFICATION_EMAIL_NOT_SENT, err

    # Shut down the connection pool, no more messages.
    smtpTransport.close()

  sms: (subject, message) ->

    ### Send an SMS using a Twilio account. ###

    @emit 'monitor:notification:sms', subject, message

    try
      sid = @config['notification:twilio:sid']
      token = @config['notification:twilio:token']
    catch err
      @err @errors.NOT_CONFIGURED_CORRECTLY, err
      return

    twilio = new TwilioAPI(
      sid
      token
    )

    twilio.account.getApplication sid, (err, app) ->
      if err
        @err @errors.TWILIO_ERROR, err

      app.register()

  webservice: (subject, message) ->

    @emit 'monitor:notification:webservice', subject, message

    try
      url = @config['notification:webservice:url']
    catch err
      @err @errors.NOT_CONFIGURED_CORRECTLY, err

    data =
      subject: subject
      message: message

    @post url, data, (data) ->
      if data.status isnt 200
        @err @errors.NOT_CONFIGURED_CORRECTLY, err