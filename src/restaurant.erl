-module(restaurant).
-export([new_cook/1, new_client/2]).


new_cook(Name) ->
    spawn_link(cook, init, [Name]).

new_client(Name, Dish) ->
    spawn_link(client, init, [Name, Dish]).
