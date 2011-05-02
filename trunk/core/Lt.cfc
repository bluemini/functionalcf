<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("Lt", arguments.contents, this)>
        
        <!--- ensure that there are at least two entries --->
        <cfif contents.length() LT 2>
            <cfthrow message="LT requires at least one argument (master [first compare [second compare]])">
        </cfif>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        <!--- get the response from running the first argument --->
        <cfset var arg = variables.contents.first()>
        <cfset var rest = variables.contents.rest()>
        <cfset var mainArg = "">
        <cfset var compArg = "">
        <cfset var result = true>
        
        <!---
        <cfif StructKeyExists(arg, "getType") AND arg.getType() IS "token">
            <cfset mainArg = arg.data>
            <cfif isNumeric(mainArg)>
        <!---
        <cfelseif isBoolean(arg)>
            <cfset mainArg = CreateObject("component", "TBoolean").init(arg)>
        <cfelseif isSimpleValue(arg)>
            <cfset mainArg = CreateObject("component", "String").init(arg)>
        --->
            <cfelseif StructKeyExists(arguments.bindMap, mainArg)>
                BINDING...<cfabort>
            <cfelse>
                <cfthrow message="arguments to LT must be entities and I'm finding a token">
            </cfif>
        <cfelse>
            <cfthrow message="call to run() must pass tokens">
        </cfif>
        --->
        
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