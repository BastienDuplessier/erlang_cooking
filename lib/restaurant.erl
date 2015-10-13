-module(restaurant).
-export([create/0, run/1, add_cook/2]).

create() -> spawn(?MODULE, run, [{[], []}]).

run({Cooks, Waiters}) ->
    receive
	{add_cook, Name} ->
 	    Cook = cook:create(Name),
	    run({[Cook|Cooks], Waiters});
	{add_waiter, Name} ->
 	    Waiter = cook:create(Name),
	    run({Cooks, [Waiter|Waiters]});
	status ->
	    io:format("Currently with Cooks : ~w and Waiters : ~w ", [Cooks, Waiters]),
	    run({Cooks, Waiters});
	quit -> exit(terminated)
    end.

add_cook(Restaurant, Name) ->
    Restaurant ! {add_cook, Name}.
