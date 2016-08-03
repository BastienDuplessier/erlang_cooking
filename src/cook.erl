-module(cook).
-export([init/1]).

-define(TIMEOUT, 10000).
-define(COOKTIME, 5000).

init(Name) ->
    io:format("Cook ~p was recruited.~n", [Name]),
    run(Name).

run(Name) ->
    receive
        {order, Order, From} ->
            io:format("Cook ~p received order.~n", [Name]),
            cook(Name, Order, From);
        terminate ->
            io:format("Cook ~p was fired !~n", [Name]),
            ok
    after ?TIMEOUT ->
            io:format("Cook ~p is waiting orders.~n", [Name]),
            run(Name)
    end.

cook(Name, {Dish, For}, From) ->
    io:format("Cook ~p stating to cook ~p !~n", [Name, Dish]),
    receive
    after ?COOKTIME ->
            io:format("Cook ~p finished to cook ~p !~n ", [Name, Dish]),
            From ! {self(), {Dish, For}},
            run(Name)
    end.
