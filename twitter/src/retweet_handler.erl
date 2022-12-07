-module(retweet_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
	Id = helper:get_id(),
	Qs = cowboy_req:parse_qs(Req0),
	{_,Tweet_Bin} = lists:keyfind(<<"tweet">>, 1, Qs),
	Binders_Bin = cowboy_req:binding(name, Req0),
	Username = binary_to_list(Binders_Bin),
	Tweet = binary_to_list(Tweet_Bin),
	A = client:retweet(Username, Tweet, Id),
	io:fwrite("~p ~n",[A]),
	Req = cowboy_req:reply(303, #{
    <<"location">> => list_to_binary("/" ++ (Username)  ++ "/main")
}, Req0),
	{ok, Req, State}.

