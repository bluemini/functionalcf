<cfcomponent implements="ICompare">
    
    <cfset variables.val = CreateObject("component", "Nil")>

    <cffunction name="init">
        <cfargument name="val" type="TBoolean">
        <cfset variables.val = arguments.val>
        <cfreturn this>
    </cffunction>
    
    <cffunction name="AND">
        <cfargument name="comp" type="TBoolean">
        <cfif isBoolean(variables.val) AND variables.val AND comp.bool>
            <cfreturn CreateObject("component", "TBoolean").init(true)>
        <cfelse>
            <cfreturn CreateObject("component", "TBoolean").init(false)>
        </cfif>
    </cffunction>
    
    <cffunction name="OR">
        <cfargument name="comp" type="TBoolean">
        <cfif (isBoolean(variables.val) AND variables.val) OR comp.bool>
            <cfreturn CreateObject("component", "TBoolean").init(true)>
        <cfelse>
            <cfreturn CreateObject("component", "TBoolean").init(false)>
        </cfif>
    </cffunction>
    
    <cffunction name="equals" returntype="TBoolean">
        <cfargument name="compareTo" type="any">
    </cffunction>
    <cffunction name="compareTo" returntype="TBoolean"></cffunction>

</cfcomponent>