{application, 'twitterws', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['client','helper','main_handler','register_handler','twitter','twitterws_app','twitterws_sup']},
	{registered, [twitterws_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {twitterws_app, []}},
	{env, []}
]}.