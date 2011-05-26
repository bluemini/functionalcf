<h3>Declare the println function</h3>
<p>$("defn println [string] (core println string)");</p>
<cfset $("defn println [string & more] (core println string & more)")>

<h3>Define an arity based greeting function</h3>

<p>$("defn greeting [username] (println 'Bobbins, ' username)")</p>
<cfset $("defn greeting [username] (println 'Bobbins, ' username)")>

<h3>define coll as a collection $("def coll [1 2]")</h3>
<cfset $("def coll [1 2]")>

<h3>fetch the first term of coll $("first coll")</h3>
<cfset $("first coll")>

<h3>print hello to the screen $("println 'Hello, '")</h3>
<cfset $("println 'Hello, '")>

<h3>Call with no arguments $("greeting 'Nick'")</h3>
<cfset $("greeting 'Nick'")>

<!--- 	<cfset $(greeting, "world")>
--->