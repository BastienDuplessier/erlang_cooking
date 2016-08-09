-module(restaurant).
-export([init/1, run/1]).

-record(state, {name, cooks=[], servers=[], clients=maps:new()}).

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
        terminate ->
            % Shutdown all processes
            lists:foreach(fun(Pid) -> Pid ! terminate end, State#state.servers),
            lists:foreach(fun(Pid) -> Pid ! terminate end, State#state.cooks),
            maps:map(fun(_, Pid) -> Pid ! terminate end, State#state.clients),
            ok
    end.
