<cfcomponent>

    <cfset this.value = 0>
    
    <cffunction name="setValue">
        <cfargument name="value" type="numeric">
        <cfset this.value = arguments.value>
    </cffunction>

</cfcomponent>