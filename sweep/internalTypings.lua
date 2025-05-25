local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sweep = require(ReplicatedStorage.sweep)

-- Utility to create a test part
function CreatePart(): Part
	local new = Instance.new("Part")
	new.Name = "SweeperPart"
	new.Parent = workspace
	return new
end

print("Creating parent and child sweepers")
local parent = sweep.new()
local child = sweep.new()

-- Track the child in the parent
parent:Track(child)

-- Add some parts to the child
print("Adding parts to child sweeper")
for i = 1, 5 do
	child:Track(CreatePart())
end

print("Adding parts to parent sweeper")
for i = 1, 5 do
	parent:Track(CreatePart())
end

print("Delaying 5 seconds before wiping parent (which should also wipe child)")
task.delay(5, function()
	parent:Wipe()
end)
