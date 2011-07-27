<cfset Time = GetTickCount()><cfscript>
// define first
$("defn first [coll] (core first coll)");

// define ffirst
$("defn ffirst [coll] ( first ( first coll))");

// define fffirst
$("defn fffirst [coll] ( first ( first (first coll)))");

// define pr
$("defn pr [string & more] (core out string & more)");

// define sub/sum
$("defn sub [value-1 value-2 & more] (core sub value-1 value-2 & more)");
$("defn sum [value-1 value-2 & more] (core sum value-1 value-2 & more)");
</cfscript>
<cfoutput>cfnCore run in #GetTickCount()-Time#ms<br></cfoutput>