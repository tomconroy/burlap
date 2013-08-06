## Burlap

#### A CoffeeScript Prototyping Framework

Simulate native app functionality on the frontend with CoffeeScript and ECO templates.

Compile `burlap.coffee` along with a ECO templates in a `templates` folder.

Add nodes (like screens, pages) in `/static/nodes.json`. The `template_name` will match up to `templates/template_name.jst.eco`, and the keys in `Controllers` and `Events`.

Use `Controllers` to pass any data down to the template. It will be available in a `@data` object.

Use `Events` to bind events to the template, in the format `"eventType selector"`, e.g. `"click #thing .btn"`