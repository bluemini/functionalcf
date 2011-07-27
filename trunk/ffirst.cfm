<h3>$("def aseq [[1 2] [3 4] [5 6]]")</h3>
<cfset $("def aseq [[1 2] [3 4] [5 6] [7 8]]")>


<h2>Define ffirst</h2>

<h3>$("defn ffirst [coll] (first (first coll))")</h3>
<cfset $("defn ffirst [coll] (first (core first coll))")>

<h3>$("def colle (first aseq)")</h3>
<cfset $("def colle (first aseq)")>

<cfoutput>#colle.toString()# #colle.getType()#</cfoutput>

<h3>$("core first colle")</h3>
<cfset $("core first colle")>

<h3>$("first colle")</h3>
<cfset $("first colle")>

<cfabort>
<h3>$("ffirst aseq")</h3>
<cfset $("ffirst aseq")>


<cfabort>

<!---

<h3>$("defn ffirst [coll] (first (first coll))")</h3>
<cfset $("defn ffirst [coll] (core first (core first coll))")>

<h3>$("def aseq [1 2 3 4 5]")</h3>
<cfset $("def aseq [1 2 3 4 5]")>
--->

<h3>$("defn ffirst [coll] (core first (core first coll))")</h3>
<cfset $("defn ffirst [coll] (core first (core first coll))")>

<h3>$("ffirst aseq")</h3>
<cfset $("ffirst aseq")>

