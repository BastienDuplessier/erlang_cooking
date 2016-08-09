-module(cook).
-export([init/2]).

-define(TIMEOUT, 10000).
-define(COOKTIME, 5000).
-record(state, {name, from}).

init(Name, From) ->
    io:format("Cook ~s was recruited.~n", [Name]),
    run(#state{name=Name,from=From}).

run(State) ->
    receive
        {order, Order, Client} ->
            io:format("Cook ~s received order.~n", [State#state.name]),
            cook(State, Order, Client);
        terminate ->
            io:format("Cook ~s was fired !~n", [State#state.name]),
            ok
    after ?TIMEOUT ->
            io:format("Cook ~s is waiting orders.~n", [State#state.name]),
            run(State)
    end.

cook(State, Dish, Client) ->
    io:format("Cook ~s stating to cook ~s !~n", [State#state.name, Dish]),
    receive
    after ?COOKTIME ->
            io:format("Cook ~s finished to cook ~s !~n ", [State#state.name, Dish]),
            State#state.from ! {finished, {Dish, Client}, self()},
            run(State)
    end.
