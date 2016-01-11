defmodule Workshop.Exercise.LinksCheck.Helper do
  def exec(solution_dir) do
    "links.ex"
    |> Path.expand(solution_dir)
    |> Code.require_file

    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.LinksCheck.run()
  end
end
