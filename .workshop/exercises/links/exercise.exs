defmodule Workshop.Exercise.Links do
  use Workshop.Exercise

  @title "Links"
  @weight 2

  @description """
  # What is a link?

      *TODO*: Short description, abnormal situations, important: links are bidirectional!

  # Origin

      *TODO*: C-links, hardware

  # Why do we need it?

      *TODO*: Automatic clean-up, connecting two entities together, binding two things together.

  # Spawning and linking

      *TODO*: Anti-pattern! Say a word about spawn_link, but in this assignment we won't use it.
  """

  @task """
  In the `Links` module implement body of function `start_dater_and_timer`, which will:

    * Return list of *PIDs* of newly created processes.
    * Process called `dater` should listen to messages with format:
      * `{:what_date_is_it, pid}` and should return tuple of three elements with current year, month and day.
    * Process called `timer` should listen to messages with format:
      * `{:what_time_is_it, pid}` and should return tuple of three elements with current hour, minute and second.
    * If any of the processes receives unexpected message, both should crash.
  """

  @hint [
    "The most important function for this assignment is `Process.link/1`.",
    "Date and time calls should use the same module and function as in the previous assignment.",
    "Spawning and linking separately is done asynchronously - `:timer.sleep/1` can help.",
    "Keep in mind, that links works in abnormal situations - `:normal` exit is not enough to trigger them!"
  ]
end
