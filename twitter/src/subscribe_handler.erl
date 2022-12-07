-module(subscribe_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
	Id = helper:get_id(),
	Qs = cowboy_req:parse_qs(Req0),
	{_, Name} = lists:keyfind(<<"name">>, 1, Qs),
	Username = binary_to_list(cowboy_req:binding(name, Req0)),
	A = client:subscribe(Username,binary_to_list(Name), Id),
	io:fwrite("~p ~n",[A]),
	Req = cowboy_req:reply(303, #{
    <<"location">> => list_to_binary("/" ++ (Username)  ++ "/main")
}, Req0),
	{ok, Req, State}.
