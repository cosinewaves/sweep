-- sweeper.lua

local internalTypings = require(script.Parent.internalTypings)
local errors = require(script.Parent.errors)

local sweeper = {} :: internalTypings.sweeper
sweeper.__index = sweeper

--[=[
  @class sweeper

  Base class for sweep. Handles object tracking and cleanups.
]=]

--[=[
  Creates a brand new sweeper class. This class is equivalent to `Janitor.new()` or `Trove.new()` .
  ```lua
  local mySweeper = sweeper.new()

@within sweeper
@return sweeper
]=]
function sweeper.new(): internalTypings.sweeper
return setmetatable({
_bucket = {},
OnTrack = function() end,
OnWipe = function() end,
} , sweeper)
end

--[=[
Adds an object for sweeper to track. It can track parts, functions, RBXScriptConnections, and custom classes with a Destroy function.
You can optionally tag the task for grouped cleanup later.

local mySweeper = sweeper.new()
mySweeper:Track(Instance.new("Part"))
mySweeper:Track(function() print("My Function!") end)
mySweeper:Track(game.Players.PlayerAdded:Connect())
mySweeper:Track(vfxPart, "effects")

@method Track
@within sweeper
@param task sweeperTask
@param tag string?
@error invalidTask -- This happens if the passed object doesn't pass the type assertion.
@return sweeperTask
]=]
function sweeper:Track(task: internalTypings.sweeperTask, tag: string?): internalTypings.sweeperTask
local isValid =
typeof(task) == "Instance"
or typeof(task) == "RBXScriptConnection"
or typeof(task) == "function"
or (typeof(task) == "table" and typeof(task.Destroy) == "function")

if not isValid then
errors.new(":Track()", "invalidTask", 3)
end

table.insert(self._bucket, {
task = task,
tag = tag,
})

self.OnTrack(task)
return task
end

--[=[
Handles cleanup for every object inside the sweeper's bucket.
If a tag is provided, only objects with that tag are cleaned up.

local mySweeper = sweeper.new()
mySweeper:Wipe() -- wipes all
mySweeper:Wipe("effects") -- wipes only "effects" tagged items

@method Wipe
@within sweeper
@param tag string?
@error invalidInstance -- This happens when it tries to cleanup an instance which isn't inside 'game' or just doesn't exist.
@return sweeper
]=]
function sweeper:Wipe(tag: string?): internalTypings.sweeper
local remaining = {}

for _, entry in self._bucket do
if tag and entry.tag ~= tag then
table.insert(remaining, entry)
continue
end

local task = entry.task

if typeof(task) == "Instance" then
  if task:IsDescendantOf(game) then
    task:Destroy()
  else
    errors.new(":Wipe()", "sweeper tried to cleanup an Instance, however the instance doesn't exist or isn't a descendant of the data model", 3)
  end
elseif typeof(task) == "RBXScriptConnection" then
  task:Disconnect()
elseif typeof(task) == "function" then
  task()
elseif typeof(task) == "table" and typeof(task.Destroy) == "function" then
  task:Destroy()
end

end

self._bucket = tag and remaining or {}
self.OnWipe()
return self
end

return sweeper
