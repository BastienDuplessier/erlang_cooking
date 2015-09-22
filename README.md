# Erlang Cooking #

This project is a little experiment about process handling with erlang.

## Build & Run ##
(WIP)

Use `make build` to compile code into erlang binaries and then use `make run` to launch the restaurant.

## Erlang Shell functions ##
(WIP)

| Command | Arguments | Effect | Notes |
|:-------:|:---------:|:------:|:-----:|
| add_waiter(1) | Name(String) | Create a waiter and add it to the restaurant | Identitifant don't need to be unique. |
| add_cook(1) | Name(String) | Create a cook and add it to the restaurant | Identifiant don't need to be unique. |
| add_client(1) | Name(String) | Create a client and add it to the restaurant | This client will ask for a random dish. |
| add_client(2) | Name(String), Dish(String) | Create a client and add it to the restaurant. | This client will ask a precise dish (see Arguments) |
| remove_waiter(1) | Name(String) | Remove the named waiter | If two waiter have the same name only one will be removed |
| remove_cook(1) | Name(String) | Remove the named cook | If two cook have the same name only one will be removed |
| remove_client(1) | Name(String) | Remove the named client | If two client have the same name only one will be removed |
| quit(0) | | Quit the app | |
