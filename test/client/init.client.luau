local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Middleman = require(ReplicatedStorage.Middleman).Client

Middleman.start()

Middleman.listen("Test", function(arg1)
  print("Server said arg 1 is "..arg1)
end)

task.wait(5)


Middleman.ask("Test", "testingarg1")
