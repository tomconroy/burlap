$ ->
  Main.init()

Main = do ->
  self =
    init: ->
      Model.init ->
        self.setup()
  
    setup: ->
      Burlap()
      
      Burlap.Controllers
        example: (params) ->
          {foo: Model.foo()}
      
      Burlap.Events
        example:
          'click button': (e) ->
            console.log 'Clicked!'
        

Model = do ->
  self = 
    init: (callback) ->
      $.getJSON 'static/data.json', (data) ->
        self.data = data
        callback && callback()
    
    foo: ->
      self.data.foo