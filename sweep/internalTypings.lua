--!strict
export type sweeperTask = Instance | RBXScriptConnection | () -> () | { Destroy: () -> () }
export type sweeper = {
	_tasks: { sweeperTask },
}

return {}
