--!strict
-- internalTypings.lua

export type sweeperTask =
	Instance
	| RBXScriptConnection
	| () -> ...any
	| {
		Destroy: (self: any) -> nil
	}

export type sweeper = {
	-- Stores all tasks currently tracked
	_bucket: { sweeperTask },

	-- Adds a task to be cleaned up
	Track: (self: sweeper, task: sweeperTask) -> sweeperTask,

	-- Wipes all tracked tasks
	Wipe: (self: sweeper) -> sweeper,

	-- Fires whenever a new task is added to the bucket
	OnAdd: (task: sweeperTask) -> (),

	-- Fires whenever the bucket is wiped
	OnWipe: () -> (),

}

return {}
