<cfcomponent implements="ICompare">
    
    <cfset this.val = CreateObject("component", "Nil")>

    <cffunction name="init">
        <cfargument name="val" type="boolean">
        <cfset this.val = arguments.val>
        <cfreturn this>
    </cffunction>
    
    <cffunction name="AND">
        <cfargument name="comp" type="TBoolean">
        <cfif isBoolean(this.val) AND this.val AND comp.bool>
            <cfset this.val = true>
            <cfreturn CreateObject("component", "TBoolean").init(true)>
        <cfelse>
            <cfset this.val = false>
            <cfreturn CreateObject("component", "TBoolean").init(false)>
        </cfif>
    </cffunction>
    
    <cffunction name="OR">
        <cfargument name="comp" type="boolean">
        <cfif (isBoolean(this.val) AND this.val) OR comp>
            <cfset this.val = true>
        <cfelse>
            <cfset this.val = false>
        </cfif>
        <cfreturn CreateObject("component", "TBoolean").init(this.val)>
    </cffunction>
    
    <cffunction name="equals" returntype="TBoolean">
        <cfargument name="compareTo" type="any">
    </cffunction>
    <cffunction name="compareTo" returntype="TBoolean"></cffunction>

</cfcomponent>