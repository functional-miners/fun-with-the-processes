defmodule Workshop.Exercise.TrappingExitsCheck do
  use Workshop.Validator

  verify "that `TrappingExits.start_process_tree()` returns PID" do
    if :erlang.is_pid(TrappingExits.start_process_tree()) do
      :ok
    else
      {:error, "Function `TrappingExits.start_process_tree()` should return PID of *supervisor* process."}
    end
  end

  verify "that supervisor process should return pids of manager, `dater` and `timer`" do
    pid = TrappingExits.start_process_tree()

    :timer.sleep(200)

    if :erlang.is_pid(pid) do
      send(pid, {:pids, self()})

      receive do
        {:pids, map} ->
          pids = Map.values(map)

          if Enum.count(pids) == 3 and Enum.all?(pids, &(:erlang.is_pid/1)) do
            :ok
          else
            {:error, "Returned empty map of provided list doesn't contain proper PIDs."}
          end

      after 2000 ->
        {:error, "Supervisor doesn't respond with PIDs list after 2 seconds. Come on!"}
      end
    else
      {:error, "Function `TrappingExits.start_process_tree()` should return PID of *supervisor* process."}
    end
  end

  verify "that all managed processes will collapse when one dies" do
    pid = TrappingExits.start_process_tree()

    :timer.sleep(200)

    if :erlang.is_pid(pid) do
      send(pid, {:pids, self()})

      receive do
        {:pids, process_map} ->
          pids = Map.values(process_map)

          if Enum.all?(pids, &(:erlang.is_process_alive/1)) do
            send(process_map[:dater], :boom)

            :timer.sleep(200)

            if Enum.any?(pids, &(:erlang.is_process_alive/1)) do
              alive_processes = Enum.filter(pids, &(:erlang.is_process_alive/1))

              {:error, "Processes didn't died - still alive: #{inspect alive_processes}."}
            else
              :ok
            end
          else
            {:error, "Processes should be alive after initialization, but they're not."}
          end

      after 2000 ->
          {:error, "Supervisor doesn't respond with PIDs list after 2 seconds. Come on!"}
      end
    else
      {:error, "Function `TrappingExits.start_process_tree()` should return PID of *supervisor* process."}
    end
  end

  verify "that supervisor should stay alive even if all other processes will die" do
    pid = TrappingExits.start_process_tree()

    :timer.sleep(200)

    if :erlang.is_pid(pid) do
      send(pid, {:pids, self()})

      receive do
        {:pids, process_map} ->
          pids = Map.values(process_map)

          if Enum.all?(pids, &(:erlang.is_process_alive/1)) do
            send(process_map[:dater], :boom)

            :timer.sleep(200)

            if :erlang.is_process_alive(pid) do
              :ok
            else
              {:error, "Supervisor died! It shouldn't - try to read about trapping exits :("}
            end
          else
            {:error, "Processes should be alive after initialization, but they're not."}
          end

      after 2000 ->
          {:error, "Supervisor doesn't respond with PIDs list after 2 seconds. Come on!"}
      end
    else
      {:error, "Function `TrappingExits.start_process_tree()` should return PID of *supervisor* process."}
    end
  end
end
