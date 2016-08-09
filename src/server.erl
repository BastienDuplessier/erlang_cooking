-module(server).
-export([init/2]).

-define(TIMEOUT, 10000).
-record(state, {name, from}).

init(Name, From) ->
    io:format("Server ~s was recruited.~n", [Name]),
    run(#state{name=Name,from=From}).

run(State) ->
    receive
        terminate ->
            io:format("Server ~s was fired !~n", [State#state.name]),
            ok
    after ?TIMEOUT ->
            io:format("Server ~s is waiting orders.~n", [State#state.name]),
            run(State)
    end.
