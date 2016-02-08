defmodule Workshop.Exercise.Bacteria do
  use Workshop.Exercise

  @title "Bacteria 101"
  @weight 100

  @description ~S"""
  # Overview

  We will implement module called `Bacteria` which will be a part of our simulation.

  # Used elements

  ## Spawning new process

  ## Process loop

  ## Receiving messages

  ## Sending messages

  ## Process dictionary

  ## Exit signals

  """

  @task ~S"""
  - Module should be called `Bacteria`.
  - It should have `new/2` function which will spawn new process and return its *PID*.
    - It will receive as a first argument *PID* of process which is a receiver of emitted events.
    - We call this process an *orchestrator*.
    - Also it should store its position, provided as a second argument - tuple with two elements `{x, y}`.
    - It should also has the round counter in the state (initialized by default to *0*).
  - `Bacteria` should consume following messages:
    - `{:next_round, number}` - It should set provided number as a round counter in the `Bacteria` state.
    - `{:get_position, caller_pid}` - It should return position provided in an initial call.
    - `{:die, caller_pid}` - It should die immediately after receiving that message, without invoking any error.
    - Any other message should result with *process crash*.
  - `Bacteria` should also emit following events:
    - Every 5th round `Bacteria` should send an event to *orchestrator* that it will multiplicate, with following
      structure: `{:multiplication, x, y}`
    - Every 3rd round `Bacteria` should move in a random direction (*one of 8 directions*) by *one unit* and should
      also report that fact with an event `{:moved, pid, new_x, new_y}`
  - If you will have any problems try to type `mix workshop.hint` or ask for help!
  """

  @hint [
    "If you don't know how a particular function works, look up it's documentation in IEx with `h`.",
    "You can check if your process is alive by `Process.alive?(pid)`.",
    "If you didn't save the PID, you can construct it by `pid(x, y, z)`.",
    "You can generate random numbers in range `1 .. N` with `:random.uniform(N)`.",
    "But regarding random numbers - you have to initialize a seed in proper process - *process dictionary* remember?"
  ]
end
