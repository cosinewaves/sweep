--!strict
-- internalTypings.lua

export type sweeperTask =
	Instance
	| RBXScriptConnection
	| () -> ...any
	| {
		Destroy: (self: any) -> nil
	}

export type taggedTask = {
	task: sweeperTask,
	tag: string?,
}

export type sweeper = {
	-- Stores all tasks currently tracked
	_bucket: { taggedTask },

	-- Adds a task to be cleaned up
	Track: (self: sweeper, task: sweeperTask, tag: string?) -> sweeperTask,

	-- Wipes all tracked tasks or those with a specific tag
	Wipe: (self: sweeper, tag: string?) -> sweeper,

	-- Fires whenever a new task is added to the bucket
	OnTrack: (task: sweeperTask) -> (),

	-- Fires whenever the bucket is wiped
	OnWipe: () -> (),
}

return {}
