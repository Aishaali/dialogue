Messages = new Meteor.Collection "messages"

if Meteor.isClient
  Template.startup.logged = ->
    return Session.get "user"

  Template.login.events
    "keyup #username": (event) ->
      if event.type is "keyup" and event.which is 13  # enter
        username = $("#username")
        Session.set "user", username.val()

  Template.chat.messages = ->
    return Messages.find {}, {sort: {time: -1}}

  Template.entry.events
    "keyup #new-message": (event) ->
      if event.type is "keyup" and event.which is 13  # enter
        new_message = $("#new-message")

        Messages.insert
          user: Session.get "user"
          message: new_message.val()
          time: new Date()

        # empty the form and refocus with jQuery
        new_message.val ""
        new_message.focus()

  Template.status.username = ->
    return Session.get "user"

  Template.status.events
    "click #logout": (event) ->
      Session.set "user", undefined

if Meteor.isServer
  Meteor.startup ->
    # lol
