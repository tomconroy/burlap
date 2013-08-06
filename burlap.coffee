Burlap = window.Burlap = (options) ->
  Burlap.Nodes.init(options)

Burlap.Nodes = do ->
  self = 
    init: (options) ->
      self.settings = _({
        container: '#main'
        nodeData: 'static/nodes.json'
        nodeClass: 'node'
      }).extend(options)
      
      self.controllers = {}
      self.events = {}
      self.currentNode = -1 # since we increment straight away
      self.$main = $(self.settings.container)

      $.getJSON self.settings.nodeData, (data) ->
        self.data = data
        self.setup()

    setup: ->
      # set up clicks
      $(document).on 'click', 'a[data-route]', self.linkHandler

      # set up page.js routing; they all point to self.route()
      _(self.data).each (node) ->
        page node.route, (context) ->
          self.route(node, context)

      # our index is gonna be '/#' -- makes self.back() easier
      page("/#{location.hash || '#'}")

    linkHandler: (e) ->
      e.preventDefault()

      # we're going to kill the page trail and start from zero
      if typeof $(this).data('refresh') != 'undefined'
        self.refresh = true

      # don't render the same page
      href = $(this).attr('href')
      if location.hash && "/#{location.hash}" == href
        console.log("Already on #{href}")
        Menu.close()
      else
        page(href)

    refreshNode: ->
      self.transition = false
      self.$main.find(".node:eq(#{self.currentNode})").remove()
      self.currentNode--
      page("/#{location.hash}")

    route: (node, context) ->
      # attaching the page.js context means templates can
      # access context.params in their own way;
      # self.back() needs context.path to update the url
      node.context = context

      # get additional data from the Controller corresponding to template name
      node.data = self.controllers[node.template] && self.controllers[node.template](context.params)

      nodeHtml = JST["templates/#{node.template}"](node)
      container = $('<div class="'+self.settings.nodeClass+'"></div>')

      # attach events relevant to this node from Events
      _( self.events[node.template] ).each (fn, event) ->
        eventInfo = event.split(' ')
        if eventInfo.length >= 2
          type = eventInfo[0]
          selector = eventInfo[1..-1].join(' ')
          container.on type, selector, (e) ->
            fn.call(node, e)

      # attach the current node information to the DOM element
      # so we're more context-aware
      container[0].nodeData = node

      container.html(nodeHtml)

      if self.refresh # kill everything and start the chain
        self.$main.html(container)
        self.currentNode = 0
      else # append to the current chain
        self.$main.find(".#{self.settings.nodeClass}:gt(#{self.currentNode})").remove()
        self.$main.append(container)
        self.currentNode++

      self.moveToCurrent()

    moveToCurrent: ->
      self.$main.css(left: -(self.currentNode * 100) + '%')

      self.refresh = false
      self.goingBack = false

    back: ->
      self.goingBack = true
      if self.currentNode > 0
        self.currentNode--
      node = self.getCurrentNodeElement()
      # update the url using location.hash rather than history.back(),
      # which is too problematic
      route = node[0].nodeData.context.path
      location.hash = route.substr(2)

      self.checkBackButton(route)
      self.moveToCurrent()

Burlap.Controllers = (controllers) ->
  _(Burlap.Nodes.controllers).extend(controllers)
  
Burlap.Events = (events) ->
  _(Burlap.Nodes.events).extend(events)
