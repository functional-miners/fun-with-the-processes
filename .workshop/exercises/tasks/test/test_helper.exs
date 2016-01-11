defmodule Workshop.Exercise.IexCheck.Helper do
  def exec(_solution_dir) do
    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.IexCheck.run()
  end
end
