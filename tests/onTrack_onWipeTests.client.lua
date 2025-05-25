local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sweep = require(ReplicatedStorage.sweep)

local collector = sweep.new()
print("Created new sweep class")

-- Hook into OnTrack
collector.OnTrack = function(task)
	print("Tracked task of type:", typeof(task))
end

-- Hook into OnWipe
collector.OnWipe = function()
	print("Wipe complete")
end

function CreatePart(): Part
	local new = Instance.new("Part")
	new.Anchored = true
	new.Size = Vector3.new(1, 1, 1)
	new.Position = Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
	new.Parent = workspace
	return new
end

-- Track some parts
for i = 1, 5 do
	collector:Track(CreatePart())
end

-- Wipe all
task.delay(3, function()
	collector:Wipe()
end)
