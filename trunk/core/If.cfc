<cfcomponent extends="func" implements="IRunnable">
    
    <cfset variables.expression = "">
    <cfset variables.args = ArrayNew(1)>

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("If", arguments.contents, this)>
        
        <!--- ensure that there are at least two entries --->
        <cfset parseLen = ArrayLen(variables.parseSymbols)>
        <cfif parseLen LT 3>
            <cfthrow message="IF requires at least two arguments (expression true [false])">
        </cfif>
        
        <!--- the first argument is the expression that IF will evaluate, to extract it and
        create an instance of the function --->
        <cfset expressionLiteral = ListGetAt(variables.parseSymbols[1][1], 1, " ")>
        <cfif Left(expressionLiteral, 1) IS NOT ":" OR Len(expressionLiteral) LTE 1>
            <cfthrow message="unable to parse BASE construct: #expressionLiteral#">
        </cfif>
        <cfset expressionLiteral = variables.parseSymbols[Right(expressionLiteral, Len(expressionLiteral)-1)][1]>
        <cfset variables.expression = CreateObject("component", "List").init(expressionLiteral).run()>
        
        <cfloop from="3" to="#parseLen#" index="argIndex">
            <cfset arg = variables.parseSymbols[argIndex]>
            <cfif isNumeric(arg[1])>
                <cfset ArrayAppend(variables.args, CreateObject("component", "Number").init(arg[1]))>
            <cfelseif isBoolean(arg[1])>
                <cfset ArrayAppend(variables.args, CreateObject("component", "TBoolean").init(arg[1]))>
            <cfelseif isSimpleValue(arg[1])>
                <cfset ArrayAppend(variables.args, CreateObject("component", "String").init(arg[1]))>
            <cfelse>
                <cfset ArrayAppend(variables.args, arg[1])>
            </cfif>
        </cfloop>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        <!--- get the response from running the first argument --->
        <cfset var check = variables.expression.run()>
        <cfif check>
            <cfreturn variables.args[1].run()>
        <cfelse>
            <cfif ArrayLen(variables.args) GTE 2>
                <cfreturn variables.args[2].run()>
            <cfelse>
                <cfreturn CreateObject("compoennt", "TBoolean").init(false).run()>
            </cfif>
        </cfif>
    </cffunction>

</cfcomponent>