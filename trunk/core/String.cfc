<cfcomponent implements="ICompare">
    
    <cfset variables.val = "">
    <cfset variables.dataFinalized = false>
    <cfset this.data = "">

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

    <!--- takes a char at a time and fills its internal array --->
    <cffunction name="parseInc">
        <cfargument name="char">
        
        <cfset var result = false>
        
        <cfif variables.dataFinalized><cfthrow message="list is immutable and cannot be modified"></cfif>
        
        <cfif char IS NOT "'">
            <cfset variables.val &= char>
            <cfset this.data = variables.val>
        <cfelse>
            <cfset result = true>
        </cfif>
        
        <cfreturn result>
    </cffunction>
    
    <cffunction name="getType">
        <cfreturn "String">
    </cffunction>
    
</cfcomponent>