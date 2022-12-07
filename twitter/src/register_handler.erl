-module(register_handler).
-import(client,[register/4]).
-import(helper, [get_id/0]).
-behavior(cowboy_handler).

-export([init/2]).
init(Req0, State) ->
	Id = get_id(),
	Qs = cowboy_req:parse_qs(Req0),
	{_, Username} = lists:keyfind(<<"name">>, 1, Qs),
	{_, Password} = lists:keyfind(<<"password">>, 1, Qs),
	{_, Email} = lists:keyfind(<<"email">>, 1, Qs),
	A = client:register(binary_to_list(Username), binary_to_list(Password), binary_to_list(Email), Id),
	io:fwrite("~p ~p ~n",[binary_to_list(Username),A]),
	S1 = binary_to_list(Username)  ++ "/main",
	S = string:concat("/", S1),
	Req = cowboy_req:reply(303, #{
    <<"location">> => list_to_binary(S)
}, Req0),
	{ok, Req, State}.
