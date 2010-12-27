<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" output="true" hint="Allows you to define a function" returntype="any">
        <cfargument name="name" default="if" type="string">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("defn", arguments.contents, this)>
        
        <cfdump var="#variables.meta#" label="DEFN meta">
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        Dooby dooo.
    </cffunction>

</cfcomponent>