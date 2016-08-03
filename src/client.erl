-module(client).
-export([init/2]).

-record(state, {name, dish}).

-define(TIMEOUT, 10000).


init(Name, Dish) ->
    io:format("Client ~s arrives in the restaurant.~n", [Name]),
    wait_server(#state{name=Name, dish=Dish}).

wait_server(State) ->
    receive
        terminate ->
            io:format("Client ~s is gone.~n", [State#state.name]),
            ok
    after ?TIMEOUT ->
            io:format("Client ~s is waiting.~n", [State#state.name]),
            wait_server(State)
    end.
