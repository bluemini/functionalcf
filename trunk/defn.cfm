<h3>Defining a basic function</h3>
<cfset $("defn isNegative [num] (lt num 0)")>

<h3>Calling the function</h3>
<pre>$("isNegative -2")</pre>
<cfset $("isNegative -2")>

<h3>Calling the function</h3>
<pre>$("isNegative 2")</pre>
<cfset $("isNegative 2")>

<cfabort>


<h3>Defining the function</h3>
<cfset $("defn myfunc [num denom] (if (lt num denom) 'less than one' 'greater than or equal to one')")>

<h3>Calling the function</h3>
<cfset $("myfunc 1 2")>

<cfabort>
<cfdump var="#variables#">
<cfabort>

<cfset $("1 2 3")>
