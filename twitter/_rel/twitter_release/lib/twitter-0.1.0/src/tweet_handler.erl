-module(tweet_handler).
-behavior(cowboy_handler).
-import(helper, [get_id/0]).
-export([init/2]).

init(Req0, State) ->
	Id = get_id(),
	Qs = cowboy_req:parse_qs(Req0),
	{_,Tweet_Bin} = lists:keyfind(<<"tweet">>, 1, Qs),
	Binders_Bin = cowboy_req:binding(name, Req0),
	Username = binary_to_list(Binders_Bin),
	Tweet = binary_to_list(Tweet_Bin),
	A = client:tweet(Username, Tweet, Id),
	S = "/" ++ (Username)  ++ "/main",
	% S = string:concat("/", S1),
	Req = cowboy_req:reply(303, #{
    <<"location">> => list_to_binary(S)
}, Req0),
	io:fwrite("~p ~n",[A]),
	{ok, Req, State}.
