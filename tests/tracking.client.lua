local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sweep = require(ReplicatedStorage.sweep)

local collector = sweep.new()

function CreatePart(): Part
  local new = Instance.new("Part")
  new.Parent = workspace
  return new
end

for i = 1, 10, 1 do
  collector:Track(CreatePart())
end

task.delay(5, collector.Wipe, collector)
