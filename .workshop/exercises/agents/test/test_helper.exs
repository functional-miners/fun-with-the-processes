defmodule Workshop.Exercise.AgentsCheck.Helper do
  def exec(_solution_dir) do
    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.AgentsCheck.run()
  end
end
