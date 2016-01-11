defmodule Workshop.Exercise.MonitorsCheck.Helper do
  def exec(_solution_dir) do
    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.MonitorsCheck.run()
  end
end
