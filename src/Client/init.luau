export type ListenCallback = (...any) -> {}?

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- A dictionary where the key is the name of a event and the value a table of callbacks
local listening = {}

-- A folder containing all the RemoteEvents
local remoteEventFolder: Folder = ReplicatedStorage:WaitForChild("MiddlemanEvents")

local Client = {}

-- Gets the RemoteEvent from a event name
function getRemoteEvent(name: string): RemoteEvent
  return remoteEventFolder:FindFirstChild(name) :: RemoteEvent
end

function remoteEventCalled(name: string, ...)
  if not listening[name] then
    warn("No listening callback for "..name)
    return
  end

  for _, callback in ipairs(listening[name]) do
    local returns = callback(...)
    if not returns then continue end
    Client.ask(name, unpack(returns))
  end
end

-- Starts the client listening process
function Client.start()
  -- Connects existing remote events
  for _, remoteEvent in ipairs(remoteEventFolder:GetChildren()) do
    if not (remoteEvent:IsA("RemoteEvent") or remoteEvent:IsA("UnreliableRemoteEvent")) then return end
    remoteEvent.OnClientEvent:Connect(function(...) 
      remoteEventCalled(remoteEvent.Name, ...)
    end)
  end
  
  -- Connects new remote events
  remoteEventFolder.ChildAdded:Connect(function(remoteEvent)
    if not (remoteEvent:IsA("RemoteEvent") or remoteEvent:IsA("UnreliableRemoteEvent")) then return end
    remoteEvent.OnClientEvent:Connect(function(...) 
      remoteEventCalled(remoteEvent.Name, ...)
    end)
  end)
end

-- Adds a listening callback to a event
function Client.listen(name: string, callback: ListenCallback): number
  if not listening[name] then listening[name] = {} end
  table.insert(listening[name], callback)
  return #listening[name]
end

-- Removes one listening callback based on id
function Client.stopListening(name: string, id: number)
  listening[name][id] = nil
end

-- Removes all listening callbacks to a name
function Client.stopAllListening(name: string)
  listening[name] = nil
end

-- Call the event for server
function Client.ask(name: string, ...)
  getRemoteEvent(name):FireServer(...)
end

return Client
