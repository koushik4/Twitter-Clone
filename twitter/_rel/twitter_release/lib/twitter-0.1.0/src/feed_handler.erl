-module(feed_handler).
-behavior(cowboy_handler).

-export([init/2]).

get_html_feed([],L)->
	L;
get_html_feed(Tweets,L)->
	[H | T] = Tweets,
	X = ["<form action=\"./retweet\"><input type=\"text\" name=\"tweet\"value=\"",H,"\">", "<input type=\"submit\" value=\" retweet \"></form><br>"],
	get_html_feed(T, lists:append(L,X)).
init(Req0, State) ->
	Id = helper:get_id(),
	Username = binary_to_list(cowboy_req:binding(name, Req0)),
	A = client:get_feed(Username,Id),
	L = ["<html><head><title>twitter</title></head><body><h1>Tweitter</h1>"],
	S = get_html_feed(A, L),
	Req = cowboy_req:reply(200,
                           #{<<"content-type">> => <<"text/html">>},
                           [S,"</form></body>"],
                           Req0),
	{ok, Req, State}.
