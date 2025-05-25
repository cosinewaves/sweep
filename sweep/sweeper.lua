-- sweeper.lua

local internalTypings = require(script.Parent.internalTypings)
local errors = require(script.Parent.errors)

local sweeper = {} -- TODO type sweeper module

--[=[
  @class sweeper

  Base class for sweep. Handles object tracking and cleanup's.
]=]

--[=[
  Creates a brand new sweeper class. This class is equivalent to `Janitor.new()` or `Trove.new()` .
  ```lua
  local mySweeper = sweeper.new()
  ```

  @return sweeper internalTypings.sweeper
]=]
function sweeper.new(): internalTypings.sweeper
  return setmetatable({
		_tasks = {},
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

  @param task internalTypings.sweeperTask
  @return sweeperTask internalTypings.sweeperTask
]=]
function sweeper:Track(task: internalTypings.sweeperTask): internalTypings.sweeperTask
  -- TODO add error handling here
  table.insert(self._tasks, task)
	return task
end

return sweeper
