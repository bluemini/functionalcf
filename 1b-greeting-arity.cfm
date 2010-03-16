<cfset $(defn, 
		"greeting",
		"Returns a greeting of the form 'Hello, username.'",
		["[]", ["greeting", "world"]],
		["[username]", [println, "Hello, ", "[username]"]])>

<cfset $(greeting)>

<!--- 	<cfset $(greeting, "world")>
--->