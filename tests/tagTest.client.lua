local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sweep = require(ReplicatedStorage.sweep)

local collector = sweep.new()
print("Created new sweep class")

function CreatePart(): Part
	local new = Instance.new("Part")
	new.Anchored = true
	new.Size = Vector3.new(2, 2, 2)
	new.Position = Vector3.new(math.random(-50, 50), 10, math.random(-50, 50))
	new.Parent = workspace
	return new
end

-- Track some parts with tags
for i = 1, 10 do
	local p = CreatePart()
	collector:Track(p, "effects")
end

for i = 1, 10 do
	local p = CreatePart()
	collector:Track(p, "ui")
end

print("20 parts created and tagged")

-- Wipe only "effects"
task.delay(5, function()
	print("Wiping only 'effects' tagged tasks")
	collector:Wipe("effects")
end)

-- Wipe everything else
task.delay(10, function()
	print("Wiping remaining tasks (ui)")
	collector:Wipe()
end)
