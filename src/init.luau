local RunService = game:GetService("RunService")

local Middleman = {}

Middleman.Server = if RunService:IsServer() then require(script.Server) else nil
Middleman.Client = if RunService:IsClient() then require(script.Client) else nil

return Middleman
