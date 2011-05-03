<p>$("def aseq [[1 2] [3 4] [5 6]]")</p>
<cfset $("def aseq [[1 2] [3 4] [5 6] [7 8]]")>


<h3>Define ffirst</h3>

<p>$("defn ffirst [coll] (first (first coll))")</p>
<cfset $("defn ffirst [coll] (first (first coll))")>

<p>$("def res (first aseq)")</p>
<cfset $("def res (first aseq)")>

<cfoutput>#res.toString()# #res.getType()#</cfoutput>

<p>$("first res")</p>
<cfset $("first res")>

<p>$("ffirst aseq")</p>
<cfset $("ffirst aseq")>


<cfabort>

<!---

<p>$("defn ffirst [coll] (first (first coll))")</p>
<cfset $("defn ffirst [coll] (core first (core first coll))")>

<p>$("def aseq [1 2 3 4 5]")</p>
<cfset $("def aseq [1 2 3 4 5]")>
--->

<p>$("defn ffirst [coll] (core first (core first coll))")</p>
<cfset $("defn ffirst [coll] (core first (core first coll))")>

<p>$("ffirst aseq")</p>
<cfset $("ffirst aseq")>

