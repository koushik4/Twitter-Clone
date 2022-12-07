-module(search_subscribe_handler).
-behavior(cowboy_handler).

-export([init/2]).

get_answers(S,[])->
	S;
get_answers(S,L)->
	[H|T] = L,
	get_answers(S ++ H ++  "\n", T).
init(Req0, State) ->
    Id = helper:get_id(),
    Qs = cowboy_req:parse_qs(Req0),
    {_, Sub} = lists:keyfind(<<"subscribe">>, 1, Qs),
    Username = binary_to_list(cowboy_req:binding(name, Req0)),
    A = client:search_by_subscribe(Username, binary_to_list(Sub), Id),
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
