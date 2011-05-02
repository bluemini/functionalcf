<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset super.init("defn", arguments.contents, arguments.scope)>
        
        <!--- args is a List where the first arg should be the CF function name --->
        <cfset var f = variables.contents.first().data>
        
        <cfif StructKeyExists(this, f)>
            <cfset variables.t = this[f]>
        <cfelse>
            Noooooooooo
        </cfif>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run" returntype="any">
        <cfargument name="bindMap" type="struct" required="true">
        <cfreturn variables.t(variables.contents.rest())>
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

    <cffunction name="writeoutput">
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