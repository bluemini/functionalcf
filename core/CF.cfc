<cfcomponent implement="IRunnable">

    <cffunction name="run">
        <cfargument name="args">
        
        <!--- args is a List where the first arg should be the CF function name --->
        <cfset var f = args.first()>
        
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
        
        <cftry>
            <cfset var item = args.firstx()>
            <cfcatch><cfdump var="#args#"></cfcatch>
        </cftry>
        <cfloop condition="item IS NOT '' AND isSimpleValue(item)">
            <cfoutput>#item#<br></cfoutput>
            <cfset length += len(item)>
            <cfset args = args.restx()>
            <cfset item = args.firstx()>
        </cfloop>
        
        <cfreturn length>
    </cffunction>

</cfcomponent>