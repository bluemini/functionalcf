<h3>Defining the new function 'greeting'</h3>
<cfset $(defn, 
		"greeting",
		"Returns a greeting of the form 'Hello, username.'",
		"[username]",
		[println, "Hello, ", "[username]"])>
		
<h3>Calling 'greeting' with one argument</h3>
<cfset $(greeting, "world")>

<h3>Calling 'greeting' with no arguments - this will fail</h3>
<cftry>
	<cfset $(greeting)>
	<cfcatch>Failed with: <cfoutput>#cfcatch.message#</cfoutput></cfcatch>
</cftry>