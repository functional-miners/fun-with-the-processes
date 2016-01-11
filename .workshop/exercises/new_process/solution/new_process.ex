defmodule NewProcess do
  defp timer() do
    receive do
      {:what_time_is_it, who} -> send(who, {:time, :calendar.local_time})
      _                       -> Process.exit(self(), :normal)
    end
    timer()
  end

  def start_timer() do
    spawn(fn -> timer() end)
  end
end
