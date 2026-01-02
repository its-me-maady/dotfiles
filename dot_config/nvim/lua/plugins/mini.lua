return {
	{
		"nvim-mini/mini.surround",
		version = "*",
		opts = {
			custom_surroundings = {
				v = {
					input = { { "%{%{().-()%}%}" }, "^.+$" },
					output = { left = "{{ ", right = " }}" },
				},
				["%"] = {
					input = { { "%{%%().-()%%%}" }, "^.+$" },
					output = { left = "{% ", right = " %}" },
				},
			},
		},
	},

	{
		"nvim-mini/mini.pairs",
		version = "*",
		event = "InsertEnter",
		opts = {},
	},
}
