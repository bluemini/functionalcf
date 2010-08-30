<h3>Define an arity based greeting function</h3>
<p>$(defn, 
		"greeting",
		"Returns a greeting of the form 'Hello, username.'",
		["[]", ["greeting", "world"]],
		["[username]", [println, "Hello, ", "[username]"]])</p>
<cfset $(defn, 
		"greeting",
		"Returns a greeting of the form 'Hello, username.'",
		["[]", ["greeting", "world"]],
		["[username]", [println, "Hello, ", "[username]"]])>

<h3>Call with not arguments $(greeting)</h3>
<cfset $(greeting)>

<!--- 	<cfset $(greeting, "world")>
--->