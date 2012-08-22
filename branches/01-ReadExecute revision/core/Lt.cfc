<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="inputData" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("Lt", arguments.inputData, this)>
        
        <!--- ensure that there are at least two entries --->
        <cfif variables.inputData.length() LT 2>
            <cfthrow message="LT requires at least one argument (master [first compare [second compare]])">
        </cfif>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        <!--- get the response from running the first argument --->
        <cfset var arg = variables.inputData.first()>
        <cfset var rest = variables.inputData.rest()>
        <cfset var mainArg = "">
        <cfset var compArg = "">
        <cfset var result = true>
        
        <!--- get each element, compare --->
        <cfloop condition="result AND rest.length() GT 0">
            
            <!--- get the value from the argument list, binding as appropriate --->
            <!--- TODO: replace this iteration with a seq --->
            <cfif StructKeyExists(arg, "getType") AND arg.getType() IS "token">
                <cfset mainArg = arg.data>
                <cfif isNumeric(mainArg)>
                <cfelseif StructKeyExists(arguments.bindMap, mainArg) AND isNumeric(arguments.bindMap[mainArg])>
                    <cfset mainArg = arguments.bindMap[mainArg]>
                <cfelse>
                    <cfdump var="#bindMap#">
                    <cfthrow message="arguments to LT must be numeric entities or a binding that maps to one.">
                </cfif>
            <cfelse>
                <cfthrow message="call to run() must pass tokens">
            </cfif>
        
            <cfset compArg = rest.first().data>
            <cfset result = result AND (mainArg LT compArg)>
            <cfset mainarg = compArg>
            <cfset rest = rest.rest()>
        </cfloop>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>