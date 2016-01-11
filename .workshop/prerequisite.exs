defmodule Workshop.Prerequisite do
  use Workshop.Validator

  verify "Should check the truth" do
    case 1 + 1 do
      2 ->
        :ok
      3 ->
        {:warning, "Math doesn't seem to work, but we'll work with it"}
      :otherwise ->
        {:error, "Something is seriously wrong with the universe"}
    end
  end
end
