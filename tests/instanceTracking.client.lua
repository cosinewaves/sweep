local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sweep = require(ReplicatedStorage.sweep)

local collector = sweep.new()
print("Created new sweep class")

function CreatePart(): Part
  local new = Instance.new("Part")
  new.Parent = workspace
  return new
end

print("Creating parts")
for i = 1, 10, 1 do
  collector:Track(CreatePart())
end
print("Created parts")

print("destorying ")
task.delay(5, collector.Wipe, collector)
