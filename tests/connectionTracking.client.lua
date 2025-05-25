local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sweep = require(ReplicatedStorage.sweep)

local collector = sweep.new() :: sweep.sweeper
local connection = RunService.RenderStepped:Connect(function(dT)
	print("Connection is alive! (RenderStepped)")
end)

collector:Track(connection)
collector:Track(RunService.Heartbeat:Connect(function()
	print("Connection is alive! (Heartbeat)")
end))

task.delay(5)
print("Wiping")
collector:Wipe()
print("Wiped")
