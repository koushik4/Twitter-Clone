{application, 'twitter', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['client','feed_handler','helper','register_handler','retweet_handler','search_hashtag_handler','search_mention_handler','search_subscribe_handler','subscribe_handler','tweet_handler','twitter','twitter_app','twitter_sup']},
	{registered, [twitter_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {twitter_app, []}},
	{env, []}
]}.