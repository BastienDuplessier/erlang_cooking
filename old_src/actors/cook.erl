-module(cook).
-export([create/1, wait/1]).

create(Name) -> spawn(?MODULE, wait, [Name]).

wait(Name) ->
    receive
	nothing ->
	    wait(Name)
    end.
