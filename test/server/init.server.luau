local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Middleman = require(ReplicatedStorage.Middleman).Server

Middleman.start()

Middleman.register({"Test"})

Middleman.listen("Test", function(player, arg1)
  print(player.Name.." said arg 1 is "..arg1)
end)

task.wait(1)

Middleman.askAll("Test", "Arg1")

