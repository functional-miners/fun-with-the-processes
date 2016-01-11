defmodule Workshop.Exercise.NewProcessCheck.Helper do
  def exec(solution_dir) do
    "new_process.ex"
    |> Path.expand(solution_dir)
    |> Code.require_file

    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.NewProcessCheck.run()
  end
end
