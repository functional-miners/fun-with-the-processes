defmodule Workshop.Exercise.NewProcess do
  use Workshop.Exercise

  @title "Spawning new process"
  @weight 1

  @description """
  # What is a process?

      *TODO*: Short description

  # Spawn all the things!

      *TODO*: spawn, PID

  # Isolation aka "Let it crash"

      *TODO*: Crashing, exiting, observer and isolation

  # Talk to me and I'll talk with you...

      *TODO*: send, receive
  """

  @task """
  In the `NewProcess` module implement body of function `start_timer`, which will:

    * Return *PID* of newly created process.
    * Listen to incoming messages and accept only `:what_time_is_it` message, sent with *PID* of the caller.
      * It should respond with atom `:time` and should return local time as a second element in a tuple.
      * It should accept those indefinitely, without crashing.
        * But it should crash when receive anything else.
  """

  @hint [
    "When playing with processes in the `iex` shell, type `:observer.start` and go to 'Applications' tab " <>
      "to see visually how the processes and relations between them look like.",
    "Local time is handled by module `:calendar` from Erlang's standard library (look for `local_time/0`).",
    "Don't know how to repeat process loop? Try to recall recursion and *tail calls* topics from previous workshop."
  ]
end
