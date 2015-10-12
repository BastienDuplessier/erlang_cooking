-module(restaurant).
-export([create/0, run/1]).

create() -> spawn(?MODULE, run, [{[], []}]).

run({Cooks, Waiters}) ->
    receive
	status ->
	    io:format("Currently with Cooks : ~w and Waiters : ~w ", [Cooks, Waiters]),
	    run({Cooks, Waiters});
	quit -> exit(terminated)
    end.
