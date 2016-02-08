# Fun with the processes - Workshop

This workshop will introduce you to the basics of the process management and
other constructs provided in the language and standard libraries.

## Workshop

To run this workshop you will need the workshop mix tasks to be
installed.

```shell
git clone https://github.com/silesian-beamers/fun-with-the-processes
cd fun-with-the-processes
mix archive.install workshop-0.5.1.ez
```

The workshop tasks should now be available and you are ready to
run the workshop.

You can check if you have everything set up correctly with `mix workshop.doctor`.

## What's next?

Type `mix workshop.next` in the terminal to start the workshop, and
have fun!

## Playground

Sample application which will help understand and show a different point of view
for Erlang / Elixir systems.

1. How to start the playground?
  - `~ $ iex -S mix`
2. How to start the observer?
  - `iex(1)> :observer.start()`
3. How to start visualization?
  - `iex(1)> ProcessesPlayground.start_visualization()`


### FAQ

- Q: I've spawned a new process in the shell and I can't see it in the `:observer`
  *Applications* tab. What's wrong with you Erlang?
  - A: Long story short, *REPL* (so `user_drv` process) is a parent for that
    process, but immediately after linking it reverts that operation and adds a
    monitor to a newly created process. Why? In order to have stable shell and
    minimize the risk that a faulty process will kill the session. More details
    you can find here: http://ferd.ca/repl-a-bit-more-and-less-than-that.html
