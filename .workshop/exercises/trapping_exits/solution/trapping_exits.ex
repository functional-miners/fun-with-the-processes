defmodule TrappingExits do
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

  defp manager(supervisor) do
    spawn_link(fn ->
      send(supervisor, {:reporting_for_duty, :dater, self()})
      dater()
    end)

    spawn_link(fn ->
      send(supervisor, {:reporting_for_duty, :timer, self()})
      timer()
    end)

    receive do
      # Do nothing
    end
  end

  defp supervisor() do
    supervisor = self()
    manager = spawn_link(fn -> manager(supervisor) end)

    Process.flag(:trap_exit, true)

    supervisor(%{ :manager => manager })
  end

  defp supervisor(pids) do
    new_pids = receive do
      {:reporting_for_duty, key, who} ->
        Map.put_new(pids, key, who)

      {:pids, who} ->
        send(who, {:pids, pids})
        pids

      _ ->
        # Ignoring other messages.
        nil
    end

    supervisor(new_pids)
  end

  def start_process_tree() do
    spawn(fn -> supervisor() end)
  end
end
