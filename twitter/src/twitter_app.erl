-module(twitter_app).
-behaviour(application).
-import(twitter, [get_server/0]).
-import(client, []).
-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Id = twitter:get_server(),
	io:fwrite("jfdssddsf"),
	{ok, Fd} = file:open("server.txt", [write]), 
	file:write(Fd, pid_to_list(Id)),
	file:close(Fd),
	Dispatch = cowboy_router:compile([
        {'_', 
		[
	{"/", cowboy_static, {file,"/Users/srinivaskoushik/Documents/projects/DOSP/Twitter-Clone/twitter/static/register.html"}},
	{"/register",register_handler,[]},
	{"/:name/main", cowboy_static, {file,"/Users/srinivaskoushik/Documents/projects/DOSP/Twitter-Clone/twitter/static/main.html"}},
	{"/:name/tweet", tweet_handler, []},
	{"/:name//search/hashtag", search_hashtag_handler, []},
	{"/:name/search/mention", search_mention_handler, []},
	{"/:name/search/subscribe", search_subscribe_handler, []},
	{"/:name/subscribe", subscribe_handler, []},
	{"/:name/feed", feed_handler, []},
	{"/:name/retweet", retweet_handler, []}
			
		]
		}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    twitter_sup:start_link().

stop(_State) ->
	ok.
