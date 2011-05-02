<cfcomponent implement="IRunnable">

    <cffunction name="run">
        <cfargument name="args">
        
        <!--- args is a List where the first arg should be the CF function name --->
        <cfset var f = args.first().data>
        
        <cfif StructKeyExists(this, f)>
            <cfset t = this[f]>
            <cfreturn t(args.rest())>
        <cfelse>
            Noooooooooo
        </cfif>
    </cffunction>
    
    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
    </cffunction>
    
    
    <!---
    implement some functions
    --->
    <cffunction name="len">
        <cfargument name="args">
        
        <cfset var length = 0>
        <cfset var item = "">
        
        <cftry>
            <cfloop condition="args.length() GT 0">
                <cfset item = args.first()>
                <cfif item.getType() IS "String">
                    <cfset length += len(item.data)>
                </cfif>
                <cfset args = args.rest()>
            </cfloop>
            <cfcatch><cfdump var="#args#"><cfrethrow></cfcatch>
        </cftry>
        
        <cfreturn length>
    </cffunction>

</cfcomponent>