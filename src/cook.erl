-module(cook).
-export([init/2]).

-define(TIMEOUT, 10000).
-define(COOKTIME, 5000).
-record(state, {name, from}).

init(Name, From) ->
    io:format("Cook ~s was recruited.~n", [Name]),
    run(#state{name=Name,from=From}).

run(Name) ->
    receive
        {order, Order, From} ->
            io:format("Cook ~s received order.~n", [Name]),
            cook(Name, Order, From);
        terminate ->
            io:format("Cook ~s was fired !~n", [Name]),
            ok
    after ?TIMEOUT ->
            io:format("Cook ~s is waiting orders.~n", [Name]),
            run(Name)
    end.

cook(Name, {Dish, For}, From) ->
    io:format("Cook ~s stating to cook ~s !~n", [Name, Dish]),
    receive
    after ?COOKTIME ->
            io:format("Cook ~s finished to cook ~s !~n ", [Name, Dish]),
            From ! {self(), {Dish, For}},
            run(Name)
    end.
