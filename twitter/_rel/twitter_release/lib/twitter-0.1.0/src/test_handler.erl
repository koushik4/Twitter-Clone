-module(test_handler).
-behavior(cowboy_websocket).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, State) ->
	io:fwrite("fdsnjkfsnfkds"),
	{cowboy_websocket, Req, State, #{
        idle_timeout => 30000}}.

websocket_init(State) ->
	{[], State}.

websocket_handle({text, Data}, State) ->
	io:fwrite("~p ~n",[(Data)]),
	{[{text, Data}], State};
websocket_handle({binary, Data}, State) ->
	{[{binary, Data}], State};
websocket_handle(_Frame, State) ->

	{reply,[{text,"Hello Beother"}], State}.

websocket_info(_Info, State) ->

	{[], State}.
