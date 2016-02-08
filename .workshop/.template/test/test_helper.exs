defmodule Workshop.Exercise.BacteriaCheck.Helper do
  def exec(solution_dir) do
    "bateria_101.ex"
    |> Path.expand(solution_dir)
    |> Code.require_file

    Code.require_file("check.exs", __DIR__)

    Workshop.Exercise.BacteriaCheck.run()
  end
end
