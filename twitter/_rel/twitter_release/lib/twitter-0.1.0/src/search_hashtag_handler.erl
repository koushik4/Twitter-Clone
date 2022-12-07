-module(search_hashtag_handler).

-import(helper, [get_id/0]).

-behavior(cowboy_handler).

-export([init/2]).

get_answers(S,[])->
	S;
get_answers(S,L)->
	[H|T] = L,
	get_answers(S ++ H ++  "\n", T).
init(Req0, State) ->
    Id = get_id(),
    Qs = cowboy_req:parse_qs(Req0),
    {_, Hashtag} = lists:keyfind(<<"hashtag">>, 1, Qs),
    Username = binary_to_list(cowboy_req:binding(name, Req0)),
    A = client:search_by_hashtag(Username, binary_to_list(Hashtag), Id),
	B = get_answers("", A),
    io:format("~p ~n", [A]),
    Req = cowboy_req:reply(200,
                           #{<<"content-type">> => <<"text/html">>},
                           ["<html>\n    <head>\n        <title>twitter</title>\n    </head>\n<bo"
                            "dy><p>",
                            B,
                            "</p></body"],
                           Req0),

    % S = "/" ++ Username  ++ "/main",
    %         Req = cowboy_req:reply(303, #{
    %     <<"location">> => list_to_binary(S)
    % }, Req0),
    io:fwrite("~p ~n", [A]),
    {ok, Req, State}.
