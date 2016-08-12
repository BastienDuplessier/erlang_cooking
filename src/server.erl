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
            io:format("Server ~s is serving a client.~n", [State#state.name]),
            Client ! {take_command, self()},
            run(State);
        {order, Dish, From} ->
            io:format("Server ~s received order for ~s from the client.~n", [State#state.name, Dish]),
            State#state.from ! {order, Dish, From, self()},
            run(State);
        {send, Dish, Client} ->
            io:format("Server ~s serving ~s.~n", [State#state.name, Dish]),
            Client ! {send, Dish},
            State#state.from ! {return, self()},
            run(State);
        {bill, Client} ->
            io:format("Server ~s is giving the bill to the client.~n", [State#state.name]),
            Client ! {ask_to_pay, 20, self()},
            run(State);
        {pay, Amount, ClientName} ->
            io:format("Server ~s got the pay from ~s.~n", [State#state.name, ClientName]),
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
