defmodule Workshop.Exercise.LinksCheck.Helper do
  def exec(_solution_dir) do
    Code.require_file("check.exs", __DIR__)
    Workshop.Exercise.LinksCheck.run()
  end
end
