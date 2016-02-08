defmodule Workshop.Exercise.BacteriaCheck do
  use Workshop.Validator

  # defmacrop check_the_same(expected, given) do
  #   quote do
  #     if unquote(expected) == unquote(given) do
  #       :ok
  #     else
  #       {:error,
  #        "Expected `#{unquote(Macro.to_string(given))}`to have the same result " <>
  #          "as `#{unquote(Macro.to_string(expected))}` - " <>
  #          "#{inspect unquote(expected)}, instead got: #{inspect unquote(given)}."}
  #     end
  #   end
  # end

  verify "" do
    :ok
  end
end
