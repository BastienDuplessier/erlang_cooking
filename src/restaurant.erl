-module(restaurant).
-export([new_cook/1]).


new_cook(Name) ->
    spawn_link(cook, init, [Name]).

