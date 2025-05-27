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
  @return sweeper
]=]
function sweeper.new(): internalTypings.sweeper
  local self = {} :: internalTypings.sweeper
  self._bucket = {}
  self.OnTrack = function() end
  self.OnWipe = function() end
  return setmetatable(self, sweeper)
end

--[=[
  Adds an object for sweeper to track. It can track parts, functions, RBXScriptConnections, custom classes with a Destroy function, and other sweepers
  ```lua
  local mySweeper = sweeper.new()
  mySweeper:Track(Instance.new("Part"))
  mySweeper:Track(function() print("My Function!") return nil end)
  mySweeper:Track(game.Players.PlayerAdded:Connect())
  ```

  @method Track
  @within sweeper
  @param task sweeperTask
  @param tag string? -- Optional tag for categorizing tasks
  @error invalidTask -- This happens if the passed object doesn't pass the type assertion.
  @return sweeperTask
]=]
function sweeper:Track(task: internalTypings.sweeperTask, tag: string?): internalTypings.sweeperTask
  local isValid =
    typeof(task) == "Instance"
    or typeof(task) == "RBXScriptConnection"
    or typeof(task) == "function"
    or (typeof(task) == "table" and typeof(task.Destroy) == "function")
    or getmetatable(task) == sweeper

  if not isValid then
    errors.new(":Track()", "invalidTask", 3)
  end

  if task == self then
    errors.new(":Track()", "cannot track self", 3)
  end

  table.insert(self._bucket, {
    task = task,
    tag = tag,
  })

  self.OnTrack(task)
  return task
end

--[=[
  Untracks a task from the bucket without cleaning it up.
  ```lua
  mySweeper:Untrack(someTask)
  ```

  @method Untrack
  @within sweeper
  @param task sweeperTask
  @return sweeper
]=]
function sweeper:Untrack(task: internalTypings.sweeperTask): internalTypings.sweeper
  for i = #self._bucket, 1, -1 do
    if self._bucket[i].task == task then
      table.remove(self._bucket, i)
      break
    end
  end
  return self
end

--[=[
  Handles cleanup for every object inside the sweeper's bucket, optionally by tag.
  ```lua
  local mySweeper = sweeper.new()
  mySweeper:Wipe() -- wipes all
  mySweeper:Wipe("effects") -- wipes only tasks with the tag "effects"
  ```

  @method Wipe
  @within sweeper
  @param tag string? -- Optional tag to filter tasks by
  @error invalidInstance -- This happens when it tries to cleanup an instance which isn't inside 'game' or just doesn't exist.
  @return sweeper
]=]
function sweeper:Wipe(tag: string?): internalTypings.sweeper
  for _, item in self._bucket do
    if tag and item.tag ~= tag then
      continue
    end

    local task = item.task
    local meta = getmetatable(task)

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
    elseif meta == sweeper then
      task:Wipe()
    end
  end

  if tag then
    for i = #self._bucket, 1, -1 do
      if self._bucket[i].tag == tag then
        table.remove(self._bucket, i)
      end
    end
  else
    table.clear(self._bucket)
  end

  self.OnWipe()
  return self
end

--[=[
  Returns how many items are currently being tracked by the sweeper object.

  @within sweeper
  @return number?
]=]
function sweeper:CountTracked(): number?
  return #self._bucket or nil
end

function sweeper:GetTasksByType(taskType: string): {internalTypings.sweeperTask}?
  local _t = {}
  if taskType:lower() == "rbxscriptconnection" then
    for i: number, sweeperTask: internalTypings.taggedTask in self._bucket do
    -- TODO this function
      return nil
    end
  end
  return nil
end

return sweeper
