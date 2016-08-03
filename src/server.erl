-module(server).
-export([init/1]).

-define(TIMEOUT, 10000).

init(Name) ->
    io:format("Server ~s was recruited.~n", [Name]),
    run(Name).

run(Name) ->
    receive
        terminate ->
            io:format("Server ~s was fired !~n", [Name]),
            ok
    after ?TIMEOUT ->
            io:format("Server ~s is waiting orders.~n", [Name]),
            run(Name)
    end.
