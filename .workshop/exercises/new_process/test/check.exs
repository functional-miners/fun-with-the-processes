defmodule Workshop.Exercise.NewProcessCheck do
  use Workshop.Validator

  verify "that `NewProcess.start_timer/0` should return a PID" do
    if :erlang.is_pid(NewProcess.start_timer()) do
      :ok
    else
      {:error, "Function `start_timer` should return a PID."}
    end
  end

  verify "that it returns actual time when asked to do" do
    pid = NewProcess.start_timer()

    if pid != nil do
      send(pid, {:what_time_is_it, self()})
      receive do
        {:time, {{_year, _month, _day}, {_hour, _minute, _second}}} ->
          :ok

        _ ->
          {:error, "Format of the response is strange, did you return a local time?"}

      after
        2000 -> {:error, "Your process does not return the time or it is too slow. We waited 2 seconds - Hurry up!"}
      end
    else
      {:error, "Function `start_timer` should return a PID."}
    end
  end

  verify "that newly created timer crashes when we sent garbage" do
    pid = NewProcess.start_timer()

    if pid != nil do
      if :erlang.is_process_alive(pid) do
        send(pid, :boom)

        :timer.sleep(100)

        if :erlang.is_process_alive(pid) do
          {:error, "Process should die after receiving unexpected message."}
        else
          :ok
        end
      else
        {:error,
         "Function `start_timer` should spawn a new process. It looks like it doesn't " <>
           " - maybe it dies right after start?"}
      end
    else
      {:error, "Function `start_timer` should return a PID."}
    end
  end

  verify "it should loop itself" do
    pid = NewProcess.start_timer()

    if pid != nil do
      send(pid, {:what_time_is_it, self()})
      receive do
        {:time, {{_year, _month, _day}, {_hour, _minute, _second}}} ->

          :timer.sleep(100)
          send(pid, {:what_time_is_it, self()})

          receive do
            {:time, {{_year, _month, _day}, {_hour, _minute, _second}}} ->
              :ok

            _ ->
              {:error, "Format of the second response is strange, did you return a local time?"}

          after
            2000 -> {:error, "Your process died after handling first message. Not good!"}
          end

        _ ->
          {:error, "Format of the response is strange, did you return a local time?"}

      after
        2000 -> {:error, "Your process does not return the time or it is too slow. We waited 2 seconds - Hurry up!"}
      end
    else
      {:error, "Function `start_timer` should return a PID."}
    end
  end
end
