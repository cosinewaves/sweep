# 🧹 sweep

`sweep` is a lightweight garbage collection utility for Roblox developers. Inspired by tools like `Trove` and `Janitor`, `sweep` helps you track and clean up instances, connections, functions, and custom objects with a simple and type-safe API.

## ✨ Features

* Track instances, connections, functions, and objects with `:Destroy()` methods
* Simple API (`:Track`, `:Wipe`)
* Type-annotated and error-safe
* Inspired by familiar patterns but minimal and clean

## 🚀 Usage

```lua
local sweep = require(game.ReplicatedStorage.sweep)

-- Create a new sweeper instance
local cleaner = sweep.new()

-- Track instances, functions, connections, or destroyable tables
local part = Instance.new("Part")
part.Parent = workspace

cleaner:Track(part)
cleaner:Track(function() print("Cleaning up!") end)
cleaner:Track(game:GetService("RunService").Heartbeat:Connect(function() end))

-- Clean everything up
cleaner:Wipe()
```

## ✅ Valid Task Types

`sweep` supports the following task types:

* `Instance` – will be destroyed if still in the DataModel
* `RBXScriptConnection` – will be disconnected
* `function` – will be called
* `table` with `.Destroy()` method – will have `:Destroy()` called

## 📘 API

### `sweep.new(): Sweeper`

Creates a new `Sweeper` object.

### `Sweeper:Track(task: SweeperTask): SweeperTask`

Adds a task to the sweeper. Throws an error if the task is invalid.

### `Sweeper:Wipe(): Sweeper`

Cleans up all tracked tasks and clears the internal bucket.

## 🛠 Type Definitions

You can find all type definitions in [`internalTypings.lua`](./internalTypings.lua).

```ts
type sweeperTask =
  Instance
  | RBXScriptConnection
  | () -> ()
  | { Destroy: () -> () }

type sweeper = {
  Track: (self: sweeper, task: sweeperTask) -> sweeperTask,
  Wipe: (self: sweeper) -> sweeper,
}
```
