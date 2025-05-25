-- sweeper.lua

local internalTypings = require(script.Parent.internalTypings)
local errors = require(script.Parent.errors)

local sweeper = {} -- type sweeper

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

function sweeper:Track(object: internalTypings.sweeperTask): internalTypings.sweeperTask

end

return sweeper
