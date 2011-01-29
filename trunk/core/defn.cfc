<cfcomponent extends="func" implements="IRunnable">

	<cffunction name="init" output="true" hint="Allows you to define a function" returntype="any">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
	    <cfset var arrKeys = structKeyArray(arguments)>
	    <cfset var arrKey = 0>
	    <cfset var attr = {}>
	    <cfset var arityCount = 1>
        <cfset var argData = ListToArray(contents._getData(), " ")>
	    <cfset attr.func = arrayNew(1)>
	    <cfset attr.comment = "">
                    
        <cfset super.init("defn", arguments.contents, this)>
        
	    <cfreturn this>
	</cffunction>
    
    <cffunction name="evaluateTree">
        <cfset var symbolLine = "">
        <cfoutput>Evaluating the tree!<cfdump var="#parseSymbols#"></cfoutput>

        <!--- a defn should have three parts to the opener: name, arguments, function body --->
        <cfif NOT StructKeyExists(parseSymbols, "sym1")>
            <cfthrow message="symbol table is empty or doesn't begin with 'SYM1'">
        </cfif>
        <cfset symbolLine = parseSymbols["SYM1"][1]>
        
        <cfif ListLen(symbolLine, " ") NEQ 3>
            <cfthrow message="DEFN requires three parameters following the function: name, arguments[] and function body">
        </cfif>
        
        <!--- establish the name of the defined function and create a UserFunc for it --->
        <cfset fnName = ListGetAt(symbolLine, 1, " ")>
        <cfset variables[fnName] = createObject("component", "UserFunc")>
        <cfoutput>Function name = #fnName#<br></cfoutput>
        
        <!--- establigh the list of arguments --->
        <cfset fnArgs = ListGetAt(symbolLine, 2, " ")>
        <cfset content.args = ListToArray(fnArgs, " ")>
        
        <!--- establish the function body --->
        <cfset fnBody = ListGetAt(symbolLine, 3, " ")>
        <cfset content.body = CreateObject("component", "List").init(fnBody)>
        
        <!--- then init() the UserFunc --->
        <cfset variables[fnName].init(content, this)>
        <cfdump var="#variables[fnName]#" label="function...">
        
        <cfabort>
    </cffunction>
    
    <cffunction name="run">
		<cfset var main = variables.parseSymbols["sym1"]>
        <cfset var func = createObject("component", "UserFunc")>
        
        <cfif ListLen(main, " ") EQ 3>
            <cfset functionName = ListGetAt(main, 1, " ")>
            <cfset functionArgs = CreateObject("component", "list").init(ListGetAt(main, 2, " "))>
            <cfset functionBody = ListGetAt(main, 3, " ")>
            <cfset variables[functionName] = func.init(functionName, functionArgs, this)>
        <cfelse>
            <cfthrow message="Unable to define a function. DEFN must be called with three args; name, arguments and body">
        </cfif>
        
        <cfreturn variables[functionName]>
    </cffunction>
    
</cfcomponent>