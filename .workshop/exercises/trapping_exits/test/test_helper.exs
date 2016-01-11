defmodule Workshop.Exercise.TrappingExitsCheck.Helper do
  def exec(_solution_dir) do
    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.TrappingExitsCheck.run()
  end
end
