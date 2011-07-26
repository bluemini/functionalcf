<p>$("def aseq [[1 2] [3 4] [5 6]]")</p>
<cfset $("def aseq [[1 2] [3 4] [5 6] [7 8]]")>


<h3>Define ffirst</h3>

<p>$("def colle (first aseq)")</p>
<cfset $("def colle (first aseq)")>

<cfoutput>#colle.toString()# #colle.getType()#</cfoutput>

<p>$("core first colle")</p>
<cfset $("core first colle")>

<p>$("first colle")</p>
<cfset $("first colle")>

<cfabort>