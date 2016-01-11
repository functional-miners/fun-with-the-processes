defmodule Workshop.Exercise.TrappingExits do
  use Workshop.Exercise

  @title "It's a trap! (Trapping exits)"
  @weight 3

  @description """
  # What does it mean to trap an exit?

      *TODO*: Short description.

  # Origin and reason why it exists

      *TODO*: Unexpected errors, "let it crash" and supervisors.

  # Spawning and linking, part 2 - Better way!

      *TODO*: Show how to handle previous, wrong, situation properly with three processes and trapping exits.
  """

  @task """
  In the `TrappingExits` module we should implement body of function `start_process_tree`, which will:

  * Return *PID* of newly created process which will act like a *supervisor*.
    * Inside of that process, we should create three new processes.
      * Each process should report its PID after creation to supervisor where we will store it for later.
    * Main process (called later a *manager*), is just below supervisor - it should spawn `dater`
      and `timer` separately.
    * As previously, process called `dater` should listen to messages with format:
      * `{:what_date_is_it, pid}` and should return tuple of three elements with current year, month and day.
    * And again, process called `timer` should listen to messages with format:
      * `{:what_time_is_it, pid}` and should return tuple of three elements with current hour, minute and second.
    * If any of the processes receives unexpected message, both should crash.
      * But, *supervisor* (not the main process) should stay alive all the time.

  Visually it should look like this:

      [ Supervisor ] ---> Main process (Manager)
                                  |------> Dater
                                  |------> Timer

  Where *supervisor* process should trap the exit signals and also it should respond on messages in format:

  * `{:pids, who}` - after receiving that message, it should return a map which contains PIDs of manager,
    `dater` and `timer`.
  * Any other message should be ignored.
  """

  @hint [
    "If you will have trouble with creating process tree, `:observer` will help you!",
    "Use `spawn_link/1` everywhere, besides *supervisor*."
  ]
end
