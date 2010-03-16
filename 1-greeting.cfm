<cfset $(defn, 
		"greeting",
		"Returns a greeting of the form 'Hello, username.'",
		"[username]",
		["[]", ["greeting", "world"]],
		["[username]", [println, "Hello, ", "[username]"]])>
		
<cfset $(greeting, "world")>
<cfset $(greeting)>