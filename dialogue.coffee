Messages = new Meteor.Collection "messages"

if Meteor.isClient
  Meteor.autosubscribe ->
    Messages.find().observe
      # when a new message is added, scroll to the bottom
      added: ->
        $("#bottom")[0].scrollIntoView()

  Template.startup.logged = ->
    return Session.get "user"

  Template.login.events
    "keyup #username": (event) ->
      if event.type is "keyup" and event.which is 13  # enter
        username = $("#username")
        Session.set "user", username.val()

  Template.chat.messages = ->
    return Messages.find {}, {sort: {time: 1}}

  Template.entry.events
    "keyup #new-message": (event) ->
      if event.type is "keyup" and event.which is 13  # enter
        new_message = $("#new-message")

        if new_message.val() isnt ""
          Messages.insert
            user: Session.get "user"
            message: new_message.val()
            time: new Date()

          # this, together with a CSS padding-bottom hack
          # on #chat-box, scrolls the last message into
          # view.
          $("#bottom")[0].scrollIntoView()

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
    # ...
