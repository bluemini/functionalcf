<h3>Defining a basic function</h3>
<pre>$("defn isNegative [num] (lt num 0)")</pre>
<cfset $("defn isNegative [num] (lt num 0)")>

<h3>Calling the function</h3>
<pre>$("isNegative -2")</pre>
<cfset $("isNegative -2")>

<h3>Calling the function</h3>
<pre>$("isNegative 2")</pre>
<cfset $("isNegative 2")>


<h2>Another DEFN example</h2>

<h3>Define a print function</h3>
<pre>$("defn sayHi [name] (println 'Hi, ' name)")</pre>
<cfset $("defn sayHi [name] (pr 'Hi, ' name)")>

<h3>Calling the function</h3>
<pre>$("sayHi 'Nick'")</pre>
<cfset $("sayHi 'Nick'")>


<h3>Defining the function</h3>
<pre>$("defn myfunc [num denom] (if (lt num denom) 'less than one' 'greater than or equal to one')</pre>
<cfset $("defn myfunc [num denom] (if (lt num denom) 'less than one' 'greater than or equal to one')")>

<h3>Calling the function</h3>
<pre>$("myfunc 1 2")</pre>
<cfset $("myfunc 1 2")>

<cfabort>
<cfdump var="#variables#">
<cfabort>

<cfset $("1 2 3")>
