<h3>Define a map: $(def, "inventors", ["Lisp", "McCarthy", "Closure", "Hickey"])</h3>
<cfset $(def, "inventors", ["Lisp", "McCarthy", "Closure", "Hickey"])>

<h3>Call the map as a function $(inventors, "Lisp")</h3>
<cfset $(inventors, "Lisp")>

<h3>Try using a FCF function as a key</h3>
<code>
&lt;cfset $(defn, "myobj", "[name]", [println, "hello, ", "[name]"])><br>
&lt;cfset $(def, "inventors", [myobj, "McCarthy", "Closure", "Hickey"])><br>
</code>
<cfset $(defn, "myobj", "[name]", [println, "hello, ", "[name]"])>
<cfset $(def, "inventors", [myobj, "McCarthy", "Closure", "Hickey"])>
<cfset $(inventors, myObj)>

<h3>To be sure, demonstrate that myObj is a real FCF</h3>
<code>&lt;cfset $(myObj, "Jerry")><br></code>
<cfset $(myObj, "Jerry")>

<h3>Setup a map with keywords</h3>
<cfset $(def, "inventors", [":Lisp", "McCarthy", ":Closure", "Hickey"])>