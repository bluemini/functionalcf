<!--- these functions define other functins, so we only need to run these once, to create the other functions --->
<cfif (NOT StructKeyExists(application, "cfn") 
            AND NOT StructKeyExists(application.cfn, "core")
            AND NOT StructKeyExists(application.cfn.core, "first"))
        OR StructKeyExists(url, "reset")>
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
</cfif>