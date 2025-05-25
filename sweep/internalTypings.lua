--!strict
-- internalTypings.lua

export type sweeperTask =
	Instance
	| RBXScriptConnection
	| () -> ...any
	| {
		Destroy: (self: any) -> nil
	}
	| sweeper -- allow nested sweeper

export type bucketItem = {
	task: sweeperTask,
	tag: string?,
}

export type sweeper = {
	_bucket: { bucketItem },

	Track: (self: sweeper, task: sweeperTask, tag: string?) -> sweeperTask,
	Wipe: (self: sweeper, tag: string?) -> sweeper,

	OnTrack: (task: sweeperTask) -> (),
	OnWipe: () -> (),

}

return {}
