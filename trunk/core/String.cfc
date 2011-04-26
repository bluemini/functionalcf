<cfcomponent implements="ICompare">

    <cffunction name="init">
        <cfargument name="val" type="string">
        <cfset variables.val = arguments.val>
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfreturn variables.val>
    </cffunction>
    
    <cffunction name="equals" returntype="TBoolean">
        <cfargument name="compareTo" type="any">
        <cfif isSimpleValue(compareTo) AND compareTo EQ variables.val>
            <cfset resp = CreateObject("component", "TBoolean").init(true)>
        <cfelse>
            <cfset resp = CreateObject("component", "TBoolean").init(false)>
        </cfif>
    </cffunction>
    <cffunction name="compareTo" returntype="TBoolean">
        <cfset resp = CreateObject("component", "TBoolean").init(true)>
    </cffunction>

</cfcomponent>