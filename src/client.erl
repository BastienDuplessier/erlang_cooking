-module(client).
-export([init/3]).

-define(TIMEOUT, 60000).
-define(EAT_TIME, 10000).
-record(state, {name, dish, from}).

init(Name, Dish, From) ->
    io:format("Client ~s arrives in the restaurant.~n", [Name]),
    run(#state{name=Name, dish=Dish, from=From}).

run(State) ->
    receive
        {take_command, From} ->
            From ! {order, State#state.dish, self()},
            run(State);
        {send, Dish} ->
            eat_dish(State, Dish);
        {ask_to_pay, Amount, Server} ->
            Server ! {pay, Amount, State#state.name},
            io:format("Client ~s has paid and now is gone.~n", [State#state.name]);
        terminate ->
            io:format("Client ~s is gone.~n", [State#state.name]),
            ok
    after ?TIMEOUT ->
            io:format("Client ~s is gone after waiting too long.~n", [State#state.name]),
            ok
    end.

eat_dish(State, Dish) ->
    io:format("Client ~s is now eating ~s.~n", [State#state.name, Dish]),
    receive
    after ?EAT_TIME ->
            State#state.from ! {finished, self()},
            run(State)
    end.
