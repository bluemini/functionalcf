<cfcomponent extends="func" displayName="FunctionalCF Core">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset super.init("defn", arguments.contents, arguments.scope)>
        
        <cfreturn this>
    </cffunction>

    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        <!--- get the response from running the first argument --->
        <cfset var arg = variables.inputData>
        <cfset var mainArg = "">
        <cfset var compArg = "">
        <cfset var result = "">
        
        <!--- get each element, compare --->
        <cfloop condition="arg.length() GT 0">
            
            <cfset mainArg = arg.first()>
            
            <!--- get the value from the argument list, binding as appropriate --->
            <cfif StructKeyExists(mainArg, "getType") AND mainArg.getType() IS "token">
                <cfset mainArg = mainArg.data>
                <cfif isNumeric(mainArg)>
                <cfelseif StructKeyExists(arguments.bindMap, mainArg) AND isSimpleValue(arguments.bindMap[mainArg])>
                    <cfset mainArg = arguments.bindMap[mainArg]>
                <cfelse>
                    <cfthrow message="arguments to STR must be simple values or a binding that maps to one."
                            detail="unable to determine a value for token: #mainArg#">
                </cfif>
            <cfelseif StructKeyExists(mainArg, "getType") AND mainArg.getType() IS "string">
                <cfset mainArg = mainArg.run()>
            <cfelse>
                <cfdump var="#mainArg#">
                <cfthrow message="call to run() must pass tokens">
            </cfif>
        
            <cfset result = result &= mainArg>
            <cfset arg = arg.rest()>
        </cfloop>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>