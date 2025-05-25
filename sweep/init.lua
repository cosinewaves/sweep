-- init.lua

local sweeper = require(script.sweeper)
local internalTypings = require(script.internalTypings)

export type sweeperTask = internalTypings.sweeperTask
export type sweeper = internalTypings.sweeper

return sweeper
