-module(client).
-export([init/3]).

-define(TIMEOUT, 60000).
-record(state, {name, dish, from}).

init(Name, Dish, From) ->
    io:format("Client ~s arrives in the restaurant.~n", [Name]),
    wait_server(#state{name=Name, dish=Dish, from=From}).

wait_server(State) ->
    receive
        terminate ->
            io:format("Client ~s is gone.~n", [State#state.name]),
            ok
    after ?TIMEOUT ->
            io:format("Client ~s is gone.~n", [State#state.name]),
            ok
    end.
