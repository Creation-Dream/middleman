wait(5)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Middleman = require(ReplicatedStorage.Middleman).Client

Middleman.start()

Middleman.listen("Test", function(arg1)
  print("Server said arg 1 is "..arg1)
  return {"testingarg1"}
end)
