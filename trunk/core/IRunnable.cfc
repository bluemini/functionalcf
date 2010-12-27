<cfinterface displayName="FunctionalCF Core" hint="">

    <cffunction name="run"></cffunction>
    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="name" type="string">
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
    </cffunction>

</cfinterface>