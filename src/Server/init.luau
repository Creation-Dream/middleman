export type ListenCallback = (player: Player, ...any) -> nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dictionary which eventname = {Callbacks}
local listening = {}

-- Folder containing all remote events.
local remoteEventFolder = Instance.new("Folder")

remoteEventFolder.Name = "MiddlemanEvents"
remoteEventFolder.Parent = ReplicatedStorage

local function getRemoteEvent(name: string): RemoteEvent
  return remoteEventFolder:FindFirstChild(name)
end

local function remoteEventCalled(name: string, player: Player, ...)
  for _, callback in ipairs(listening[name]) do
    callback(player, ...)
  end
end

local Server = {}

function Server.start()
  -- Connects existing remote events
  for _, remoteEvent in ipairs(remoteEventFolder:GetChildren()) do
    if not remoteEvent:IsA("RemoteEvent") then return end
    remoteEvent.OnServerEvent:Connect(function(player: Player, ...) 
      remoteEventCalled(remoteEvent.Name, player, ...)
    end)
  end
  
  -- Connects new remote events
  remoteEventFolder.ChildAdded:Connect(function(remoteEvent)
    if not remoteEvent:IsA("RemoteEvent") and not remoteEvent:IsA("UnreliableRemoteEvent") then return end
    remoteEvent.OnServerEvent:Connect(function(player: Player, ...) 
      remoteEventCalled(remoteEvent.Name, player, ...)
    end)
  end)
end

-- Creates remote events.
function Server.register(names: {string})
  for _, name in ipairs(names) do
    local newRemote = Instance.new("RemoteEvent")

    newRemote.Name = name
    newRemote.Parent = remoteEventFolder

    print(newRemote)
  end
end

-- Creates unreliable remote events.
function Server.registerUnreliable(names: {string})
  for _, name in ipairs(names) do
    local newRemote = Instance.new("UnreliableRemoteEvent")

    newRemote.Name = name
    newRemote.Parent = remoteEventFolder

    print(newRemote)
  end
end

-- Start listening to a event
function Server.listen(name: string, callback: ListenCallback)
  if not listening[name] then listening[name] = {} end
  table.insert(listening[name], callback)
  return #listening[name]
end

-- Stops listenings of one callback via id
function Server.stopListening(name: string, id: number)
  listening[name][id] = nil
end

-- Stops all listening to a event
function Server.stopAllListening(name: string)
  listening[name] = nil
end

-- Ask a client to do something
function Server.ask(name: string, player: Player, ...)
  getRemoteEvent(name):FireClient(player, ...)
end

-- Ask all clients to do something.
function Server.askAll(name: string, ...)
  getRemoteEvent(name):FireAllClients(...)
end

return Server
