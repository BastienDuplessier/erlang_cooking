# Erlang Cooking #

This project is a little experiment about process handling with erlang.

## Build & Run ##

To run project in development mode, just use the following :
```
rebar3 shell
```

## How to use it ##

Inside Erlang Shell, create a restaurant process :
```
Restaurant = restaurant:init("Le Restaurant de la Galère").
```

You can now add some cooks and servers :
```
Restaurant ! {new_cook, "Morsay"}.
Restaurant ! {new_cook, "Zehef"}.
Restaurant ! {new_server, "Taitai"}.
Restaurant ! {new_server, "Shlaguetto"}.
```

And then, throw them some clients !!
```
Restaurant ! {new_client, "José Mauvais", beef).
```

Now see how they handle him \o\.