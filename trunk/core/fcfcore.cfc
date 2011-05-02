<cfinterface extends="func" displayName="FunctionalCF Core">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset super.init("defn", arguments.contents, arguments.scope)>
        
        <cfreturn this>
    </cffunction>

    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
    </cffunction>

</cfinterface>