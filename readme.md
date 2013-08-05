### Coffeescript Prototyping Framework

Simulate native app functionality on with CoffeeScript and ECO templates.

Add nodes (like screens, pages) in `/static/nodes.json`. The `template_name` will match up to `templates/template_name.jst.eco`, and the keys in `Controller` and `Events`.

Use the `Controller` to pass any data down to the template. It will be available in a `@data` object.

Use `Events` to bind events to the template, in the format `"eventType selector"`, e.g. `"click #thing .btn"`