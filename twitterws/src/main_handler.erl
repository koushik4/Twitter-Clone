-module(main_handler).
-behavior(cowboy_websocket).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2,tweet/2]).

get_answers(S,[])->
	S;
get_answers(S,L)->
	[H|T] = L,
	get_answers(S ++ H ++  "\n", T).

	retweet(Username,Tweet)->
		Id = helper:get_id(),
		A = client:retweet(Username, Tweet, Id),
		A.
search(Username,Mention)->
	Id = helper:get_id(),
	A = client:search_by_subscribe(Username, Mention, Id),
	B = get_answers("", A),
	B.
mention(Username,Mention)->
	Id = helper:get_id(),
	A = client:search_by_mention(Username, Mention, Id),
	B = get_answers("", A),
	B.
hashtag(Username,Hashtag)->
	Id = helper:get_id(),
	A = client:search_by_hashtag(Username, Hashtag, Id),
	B = get_answers("", A),
	B.
tweet(Username,Tweet)->
	Id = helper:get_id(),
	A = client:tweet(Username, Tweet, Id),
	A.
subscribe(Username1,Username2)->
	Id = helper:get_id(),
	client:subscribe(Username1,Username2, Id),
	ok.
init(Req, State) ->
	{cowboy_websocket, Req, State,#{idle_timeout => 30000}}.

websocket_init(State) ->
	{[], State}.
	
websocket_handle({text, Data}, State) ->
	Splited = string:split(binary_to_list(Data), "-",all),
	Operation = lists:nth(1, Splited),
	if
		Operation == "update_handler"->
			Id = helper:get_id(),
			client:update_handler(lists:nth(2, Splited),self(),Id),
			Text = list_to_binary(""),
			{[{text, <<Text/binary>>}], State};
		Operation == "tweet"->
			tweet(lists:nth(2, Splited), lists:nth(3, Splited)),
			Text = list_to_binary(""),
			{reply,{text,<<Text/binary>>},State};
		Operation == "subscribe"->
			subscribe(lists:nth(2, Splited), lists:nth(3, Splited)),
			Text = list_to_binary("update-subscribed to "++lists:nth(3, Splited)),
			{reply,{text,<<Text/binary>>},State};
		Operation == "hashtag"->
			Ans = hashtag(lists:nth(2, Splited), lists:nth(3, Splited)),
			Text = list_to_binary("search-"++Ans),
			{reply,{text,<<Text/binary>>},State};
		Operation == "mention"->
			Ans = mention(lists:nth(2, Splited), lists:nth(3, Splited)),
			Text = list_to_binary("search-"++Ans),
			{reply,{text,<<Text/binary>>},State};
		Operation == "search"->
			Ans = search(lists:nth(2, Splited), lists:nth(3, Splited)),
			Text = list_to_binary("search-"++Ans),
			{reply,{text,<<Text/binary>>},State};
		Operation == "retweet"->
			retweet(lists:nth(2, Splited), lists:nth(3, Splited)),
			Text = list_to_binary(""),
			{reply,{text,<<Text/binary>>},State};
		true->
			Text = list_to_binary(""),
			{[{text, <<Text/binary>>}], State}
	end;

websocket_handle({binary, Data}, State) ->
	{[{binary, Data}], State};
websocket_handle(_Frame, State) ->
	{[], State}.

websocket_info(Info, State) ->
	Tweet = lists:nth(2, tuple_to_list(Info)),
	Text = list_to_binary(Tweet),
	io:fwrite("grrhggrhthrthr ~p ~n",[Info]),
	{reply, {text, <<Text/binary>>}, State}.
