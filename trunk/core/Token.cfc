<cfcomponent implements="ICompare">
    
    <cfset variables.val = "">
    <cfset variables.dataFinalized = false>
    
    <cfset ArrayAppend(request.feature, {"type"="token", "time"="#getTickCount()#"})>

    <cffunction name="init">
        <cfreturn this>
    </cffunction>
    
    <cffunction name="xinit">
        <cfargument name="val" type="string">
        <cfset variables.val = arguments.val>
        <cfreturn this>
    </cffunction>
    
    <!--- takes a char at a time and fills its internal array --->
    <cffunction name="parseInc">
        <cfargument name="char">
        
        <cfset var finished = false>
        
        <cfif variables.dataFinalized><cfthrow message="list is immutable and cannot be modified"></cfif>
        
        <cfif ListFind("[,],(,),{,}", char)>
            <cfreturn 2><!--- hit a close of containing object --->
        <cfelseif char IS NOT " ">
            <cfset variables.val &= char>
            <cfset this.data = variables.val>
            <cfreturn 0>
        <cfelse>
            <cfreturn 1><!--- other type of close --->
        </cfif>
    </cffunction>
    
    <cffunction name="getType">
        <cfreturn "Token">
    </cffunction>
    
    <cffunction name="toString">
        <cfreturn run()>
    </cffunction>
    <cffunction name="run">
        <cfreturn variables.val>
    </cffunction>
    
    <cffunction name="equals" returntype="boolean">
        <cfargument name="compareTo" type="any">
        <cfif isSimpleValue(compareTo) AND compareTo EQ variables.val>
            <cfset resp = true>
        <cfelse>
            <cfset resp = false>
        </cfif>
        <cfreturn resp>
    </cffunction>
    <cffunction name="compareTo" returntype="TBoolean">
        <cfif isNumeric(variables.val)>
            
        </cfif>
        <cfset resp = CreateObject("component", "TBoolean").init(true)>
        <cfreturn resp>
    </cffunction>

</cfcomponent>