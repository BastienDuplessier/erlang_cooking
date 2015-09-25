-module(restaurant).
-export([run/0]).

run() -> run({[], []}).

run({Cooks, Waiters}) ->
    receive
	status ->
	    io:format("Currently with Cooks : ~w and Waiters : ~w ", [Cooks, Waiters]),
	    run({Cooks, Waiters});
	quit -> exit(terminated)
    end.
