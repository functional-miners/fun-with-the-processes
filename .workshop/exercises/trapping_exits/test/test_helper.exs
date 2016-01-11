defmodule Workshop.Exercise.TrappingExitsCheck.Helper do
  def exec(solution_dir) do
    "trapping_exits.ex"
    |> Path.expand(solution_dir)
    |> Code.require_file

    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.TrappingExitsCheck.run()
  end
end
