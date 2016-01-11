defmodule Workshop.Exercise.TasksCheck.Helper do
  def exec(_solution_dir) do
    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.TasksCheck.run()
  end
end
