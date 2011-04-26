<h3>Defining the function</h3>
<cfset $("defn myfunc [num denom] (ifff (lt num denom) 'less than one' 'greater than or equal to one')")>

<cfabort>
<h3>Calling the function</h3>
<cfset $("myfunc 1 2")>


<cfdump var="#variables#">
<cfabort>

<cfset $("1 2 3")>
