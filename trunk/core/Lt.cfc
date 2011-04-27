<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("Lt", arguments.contents, this)>
        
        <!--- ensure that there are at least two entries --->
        <cfset parseLen = ArrayLen(variables.parseSymbols)>
        <cfif parseLen NEQ 1>
            <cfthrow message="LT requires a single argument (master [first compare [second compare]])">
        </cfif>
        
        <cfset variables.expression = CreateObject("component", "List").init(variables.parseSymbols[1][1])>

        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        <!--- get the response from running the first argument --->
        <cfset var arg = variables.expression.first()>
        <cfset var rest = variables.expression.rest()>
        <cfset var mainArg = "">
        <cfset var compArg = "">
        <cfset var result = CreateObject("component", "TBoolean").init(false)>
        
        <cfif isNumeric(arg)>
            <cfset mainArg = CreateObject("component", "Number").init(arg)>
        <cfelseif isBoolean(arg)>
            <cfset mainArg = CreateObject("component", "TBoolean").init(arg)>
        <cfelseif isSimpleValue(arg)>
            <cfset mainArg = CreateObject("component", "String").init(arg)>
        <cfelse>
            <cfset mainArg = arg>
        </cfif>
        
        <cfif NOT StructKeyExists(rest, "type") OR rest.type IS NOT "NIL">
            <cfset rest = rest.first()>
            <cfset result = result.OR(rest.compareTo(arg) GT 0)>
        </cfif>
        
        <cfreturn result.val>
    </cffunction>

</cfcomponent>