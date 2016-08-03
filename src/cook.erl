-module(cook).
-export([init/1]).

-define(TIMEOUT, 10000).
-define(COOKTIME, 5000).

init(Name) ->
    io:format("Cook ~s was recruited.~n", [Name]),
    run(Name).

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
