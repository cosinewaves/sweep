-- sweeper.lua

local internalTypings = require(script.Parent.internalTypings)
local errors = require(script.Parent.errors)

local sweeper = {} :: internalTypings.sweeper
sweeper.__index = sweeper


--[=[
  @class sweeper

  Base class for sweep. Handles object tracking and cleanup's.
]=]

--[=[
  Creates a brand new sweeper class. This class is equivalent to `Janitor.new()` or `Trove.new()` .
  ```lua
  local mySweeper = sweeper.new()
  ```

  @within sweeper
  @return sweeper internalTypings.sweeper
]=]
function sweeper.new(): internalTypings.sweeper
  return setmetatable({
		_bucket = {},
	}, sweeper)
end

--[=[
  Adds an object for sweeper to track. It can track parts, functions, RBXScriptConnections, and custom classes with a Destroy function
  ```lua
  local mySweeper = sweeper.new()
  mySweeper:Track(Instance.new("Part"))
  mySweeper:Track(function() print("My Function!") return nil end)
  mySweeper:Track(game.Players.PlayerAdded:Connect())
  ```

  @within sweeper
  @param task internalTypings.sweeperTask
  @error "provided task doesn't exist, or isn't a valid type - see valid taskTypes in sweep/internalTypings.lua" This happens if the passed object doesn't pass the type assertion.
  @return sweeperTask internalTypings.sweeperTask
]=]
function sweeper:Track(task: internalTypings.sweeperTask): internalTypings.sweeperTask

  if not task or typeof(task) ~= internalTypings.sweeperTask then
    errors.new(":Track()", "provided task doesn't exist, or isn't a valid type - see valid taskTypes in sweep/internalTypings.lua", 3)
  end

  table.insert(self._bucket, task)
	return task
end

--[=[
  Handles cleanup for every object inside the sweeper's bucket.
  ```lua
  local mySweeper = sweeper.new()
  mySweeper:Wipe()
  ```

  @within sweeper
  @error "sweeper tried to cleanup an Instance, however the instance doesn't exist or isn't a descendant of the data model" This happens when it tries to cleanup and instance which isn't inside 'game' or just doesn't exist.
  @return sweeper internalTypings.sweeper
]=]
function sweeper:Wipe(): internalTypings.sweeper
  for _, task in self._bucket do
  		if typeof(task) == "Instance" then
  			if task:IsDescendantOf(game) then
  				task:Destroy()
        else
          errors.new(":Wipe()",
           "sweeper tried to cleanup an Instance, however the instance doesn't exist or isn't a descendant of the data model"
         ,3)
          return self
  			end
  		elseif typeof(task) == "RBXScriptConnection" then
  			task:Disconnect()
  		elseif typeof(task) == "function" then
  			task()
  		elseif typeof(task) == "table" and typeof(task.Destroy) == "function" then
  			task:Destroy()
  		end
  	end
  	table.clear(self._bucket)
    return self
end


return sweeper
