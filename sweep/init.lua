--!strict
-- init.lua

local sweeper = require(script.sweeper :: ModuleScript)
local internalTypings = require(script.internalTypings :: ModuleScript)

export type sweeperTask = internalTypings.sweeperTask
export type sweeper = internalTypings.sweeper

return sweeper
