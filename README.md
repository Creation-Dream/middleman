# Middleman
Middleman allows a script based communication between the client and server by acting as the Middleman. It will automatically create and connect to remote events and allow you to bind callbacks or call these remote events.

# Startup
Starting the client and server modules for middleman is a very important step as it is what binds the callbacks to the events themselves.

## Server-Side Setup
Put this in any server sided script, preferably at the top.
```luau
-- Directing to the server module is better for type checking
local Middleman = require(path.to.module.Server) -- Replace path.to.module with the path to the module 
Middleman.start()
```
This will setup the module to start listening to new or old events that are registered and fire the callbacks accordingly.

Additonally, if you want to register events for the module, you should register them. You can register these events at anytime, but you should register them before using them.
```luau
Middleman.register({"NameSpaceName/Name1", "TestNameSpace/TestEvent"})
-- It's recommended that you put a namespace before the name to help with compatibility. A built-in name spacing feature will be added later.
```

## Client-Side Setup
Put this into any client sided script, preferably at the top.
```luau
local Middleman = require(path.to.module.Client) -- Replace path.to.module with the path to the module 
Middleman.start()
```
This will setup the module to start listening to new or old events that are registered and fire the callbacks accordingly for the client.

No additional registering is required for the client as the client automatically receives registrations from the server.
