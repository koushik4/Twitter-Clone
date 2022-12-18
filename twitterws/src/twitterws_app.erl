-module(twitterws_app).

-behaviour(application).

-import(twitter, [get_server/0]).
-import(client, []).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    Id = twitter:get_server(),
    {ok, Fd} = file:open("server.txt", [write]),
    file:write(Fd, pid_to_list(Id)),
    file:close(Fd),
    Dispatch =
        cowboy_router:compile([{'_',
                                [{"/",
                                  cowboy_static,
                                  {file,
                                   "/Users/srinivaskoushik/Documents/projects/DOSP/Twitter-Clone/twitter"
                                   "ws/priv/static/register.html"}},
                                 {"/register", register_handler, []},
                                 {"/:name/main",
                                  cowboy_static,
                                  {file,
                                   "/Users/srinivaskoushik/Documents/projects/DOSP/Twitter-Clone/twitter"
                                   "ws/priv/static/main.html"}}]}]),

    DispatchWs = cowboy_router:compile([{'_', [{"/", main_handler, []}]}]),
	
    {ok, _} =
        cowboy:start_clear(my_http_listener, [{port, 8081}], #{env => #{dispatch => Dispatch}}),
    {ok, _} = cowboy:start_clear(ws, [{port, 8889}], #{env => #{dispatch => DispatchWs}}),
    twitterws_sup:start_link().

stop(_State) ->
    ok.
