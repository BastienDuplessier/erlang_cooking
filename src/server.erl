-module(server).
-export([init/2]).

-define(TIMEOUT, 10000).
-record(state, {name, from}).

init(Name, From) ->
    io:format("Server ~s was recruited.~n", [Name]),
    run(#state{name=Name,from=From}).

run(State) ->
    receive
        {serve, Client} ->
            Client ! {take_command, self()},
            run(State);
        {order, Dish, From} ->
            State#state.from ! {order, Dish, From, self()},
            run(State);
        {send, Dish, Client} ->
            Client ! {send, Dish},
            State#state.from ! {return, self()},
            run(State);
        {bill, Client} ->
            Client ! {ask_to_pay, 20},
            run(State);
        {pay, Amount, ClientName} ->
            State#state.from ! {store_money, Amount, ClientName},
            State#state.from ! {return, self()},
            run(State);
        terminate ->
            io:format("Server ~s was fired !~n", [State#state.name]),
            ok
    after ?TIMEOUT ->
            io:format("Server ~s is waiting orders.~n", [State#state.name]),
            run(State)
    end.
