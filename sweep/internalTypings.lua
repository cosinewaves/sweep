--!strict
-- internalTypings.lua

export type sweeper = {
	-- Internal task storage
	_bucket: { taggedTask },

	-- Adds a task to be cleaned up
	Track: (self: sweeper, task: sweeperTask, tag: string?) -> sweeperTask,

	-- Removes a task (or tasks by tag)
	Untrack: (self: sweeper, target: sweeperTask | string) -> (),

	-- Wipes all tracked tasks, or those by tag
	Wipe: (self: sweeper, tag: string?) -> sweeper,

	-- Fires when a task is tracked
	OnTrack: (task: sweeperTask, tag: string?) -> (),

	-- Fires when wipe is executed
	OnWipe: () -> (),

	-- Returns how many items are being Tracked
	CountTracked: () -> number?,

	-- Metatable
	__index: any,
}

export type taggedTask = {
	task: sweeperTask,
	tag: string?,
}

export type sweeperTask =
	Instance
	| RBXScriptConnection
	| () -> ...any
	| {
		Destroy: (self: any) -> nil,
	}
	| sweeper

return {}
