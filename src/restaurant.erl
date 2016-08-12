-module(restaurant).
-export([init/1, run/1]).

-record(state, {
          name,
          money=0,
          cooks=[],
          servers=[],
          clients=maps:new(),
          waiting_clients=queue:new(),
          waiting_dishes=queue:new()
         }).

new_cook(Name) ->
    spawn_link(cook, init, [Name, self()]).

new_server(Name) ->
    spawn_link(server, init, [Name, self()]).

new_client(Name, Dish) ->
    spawn_link(client, init, [Name, Dish, self()]).

init(Name) ->
    spawn_link(?MODULE, run, [#state{name=Name}]).

run(State) ->
    receive
        % RECRUITMENT
        {new_cook, Name} ->
            Cooks = State#state.cooks,
            NewCook = new_cook(Name),
            run(State#state{cooks=[NewCook|Cooks]});
        {new_server, Name} ->
            Servers = State#state.servers,
            NewServer = new_server(Name),
            run(State#state{servers=[NewServer|Servers]});
        {new_client, Name, Dish} ->
            Clients = State#state.clients,
            case maps:find(Name, Clients) of
                {ok, _} ->
                    % Already exists
                    io:format("Client ~s is already in the restaurant, message will be ignored.~n", [Name]),
                    run(State);
                error ->
                    % Not yet exists
                    NewClient = new_client(Name, Dish),
                    self() ! {handle_client, NewClient},
                    run(State#state{clients=maps:put(Name, NewClient, Clients)})
            end;
        {handle_client, Client} ->
            case State#state.servers of
                [Server|Rest] ->
                    Server ! {serve, Client},
                    run(State#state{servers=[Rest]});
                [] ->
                    Waiting = State#state.waiting_clients,
                    run(State#state{waiting_clients=queue:in(Client, Waiting)})
            end;
        {order, Dish, Client, Server} ->
            Servers = [Server|State#state.servers],
            case State#state.cooks of
                [Cook|Rest] ->
                    Cook ! {order, Dish, Client},
                    check_remaining_clients(State#state{cooks=[Rest], servers=Servers});
                [] ->
                    Waiting = State#state.waiting_dishes,
                    check_remaining_clients(State#state{waiting_dishes=queue:in({order, Dish, Client}, Waiting), servers=Servers})
            end;
        {finished, {Dish, Client}, Cook} ->
            Cooks = [Cook|State#state.cooks],
            case State#state.servers of
                [Server|Rest] ->
                    Server ! {send, Dish, Client},
                    check_remaining_dishes(State#state{servers=[Rest], cooks=Cooks});
                [] ->
                    Waiting = State#state.waiting_dishes,
                    check_remaining_dishes(State#state{waiting_dishes=queue:in({dish, Dish, Client}, Waiting), cooks=Cooks})
            end;
        {finished, Client} ->
            case State#state.servers of
                [Server|Rest] ->
                    Server ! {bill, Client},
                    run(State#state{servers=Rest}),
                    run(State);
                [] ->
                    Waiting = State#state.waiting_clients,
                    run(State#state{waiting_clients=queue:in({pay, Client}, Waiting)})
            end;
        {return, Server} ->
            Servers = [Server|State#state.servers],
            check_remaining_clients(State#state{servers=Servers});
        {store_money, Amount, ClientName} ->
            Total = State#state.money + Amount,
            Clients = maps:remove(ClientName, State#state.clients),
            run(State#state{money=Total, clients=Clients});
        terminate ->
            % Shutdown all processes
            lists:foreach(fun(Pid) -> Pid ! terminate end, State#state.servers),
            lists:foreach(fun(Pid) -> Pid ! terminate end, State#state.cooks),
            maps:map(fun(_, Pid) -> Pid ! terminate end, State#state.clients),
            ok
    end.

% TO COMPLETE !!
check_remaining_clients(State) ->
    run(State).
check_remaining_dishes(State) ->
    run(State).
