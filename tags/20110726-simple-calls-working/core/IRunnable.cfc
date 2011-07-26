<cfinterface displayName="FunctionalCF Core" hint="">

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="inputData" type="any">
        <cfargument name="scope" type="any">
    </cffunction>

    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
    </cffunction>

</cfinterface>