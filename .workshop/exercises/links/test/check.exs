defmodule Workshop.Exercise.LinksCheck do
  use Workshop.Validator

  verify "that `Links.start_dater_and_timer/0` should return a list of PIDs" do
    pids = Links.start_dater_and_timer()

    if :erlang.is_list(pids) and length(pids) > 0 do
      if Enum.all?(pids, fn(pid) -> :erlang.is_pid(pid) == true end) do
        :ok
      else
        {:error, "Elements of list returned from `start_dater_and_timer` should be PIDs, but they're not."}
      end
    else
      {:error, "Function `start_dater_and_timer` should return list of PIDs."}
    end
  end

  verify "that `dater` asked about date should return it" do
    [dater, timer] = Links.start_dater_and_timer()

    if :erlang.is_pid(dater) and :erlang.is_pid(timer) do
      send(dater, {:what_date_is_it, self()})

      receive do
        {:date, {_year, _month, _day}} ->
          :ok

        _ ->
          {:error, "Format of response sent from `dater` is strange. Did you returned local date?"}

      after 2000 ->
        {:error, "Process `dater` didn't respond, but we've waited for it! :("}
      end
    else
      {:error, "Function `start_dater_and_timer` should return list of PIDs."}
    end
  end

  verify "that `timer` asked about time should return it" do
    [dater, timer] = Links.start_dater_and_timer()

    if :erlang.is_pid(dater) and :erlang.is_pid(timer) do
      send(timer, {:what_time_is_it, self()})

      receive do
        {:time, {_hour, _minute, _second}} ->
          :ok

        _ ->
          {:error, "Format of response sent from `timer` is strange. Did you returned local time?"}

      after 2000 ->
          {:error, "Process `timer` didn't respond, but we've waited for it! :("}
      end
    else
      {:error, "Function `start_dater_and_timer` should return list of PIDs."}
    end
  end

  verify "that when `timer` receives garbage and dies, `dater` also will die" do
    [dater, timer] = Links.start_dater_and_timer()

    if :erlang.is_pid(dater) and :erlang.is_pid(timer) do
      if :erlang.is_process_alive(dater) and :erlang.is_process_alive(timer) do
        send(timer, :boom)

        :timer.sleep(100)

        if not :erlang.is_process_alive(timer) do
          if not :erlang.is_process_alive(dater) do
            :ok
          else
            {:error, "Process `dater` didn't die together with `timer`."}
          end
        else
          {:error, "Process `timer` didn't exit when received unexpected message."}
        end
      else
        {:error, "Function `start_dater_and_timer` should spawn living processes."}
      end
    else
      {:error, "Function `start_dater_and_timer` should return list of PIDs."}
    end
  end

  verify "that when `dater` receives garbage and dies, `timer` also will die" do
    [dater, timer] = Links.start_dater_and_timer()

    if :erlang.is_pid(dater) and :erlang.is_pid(timer) do
      if :erlang.is_process_alive(dater) and :erlang.is_process_alive(timer) do
        send(dater, :boom)

        :timer.sleep(100)

        if not :erlang.is_process_alive(dater) do
          if not :erlang.is_process_alive(timer) do
            :ok
          else
            {:error, "Process `timer` didn't die together with `dater`."}
          end
        else
          {:error, "Process `dater` didn't exit when received unexpected message."}
        end
      else
        {:error, "Function `start_dater_and_timer` should spawn living processes."}
      end
    else
      {:error, "Function `start_dater_and_timer` should return list of PIDs."}
    end
  end
end
