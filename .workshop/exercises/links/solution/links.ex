defmodule Links do
  defp dater() do
    receive do
      {:what_date_is_it, who} ->
        {date, _time} = :calendar.local_time()
        send(who, {:date, date})

      _ ->
        Process.exit(self(), :unexpected_message)
    end
    dater()
  end

  defp timer() do
    receive do
      {:what_time_is_it, who} ->
        {_date, time} = :calendar.local_time()
        send(who, {:time, time})

      _ ->
        Process.exit(self(), :unexpected_message)
    end
    timer()
  end

  def start_dater_and_timer() do
    dater = spawn(fn -> dater() end)

    :timer.sleep(100)

    timer = spawn(fn ->
      Process.link(dater)
      timer()
    end)

    [dater, timer]
  end
end
