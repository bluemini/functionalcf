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
    
	<!---
        For defn, we need to produce a single function that can be called, but
        which encapsulates the full definition enclosed in the source. The 'parseSymbols'
		data, is produced by parsing the contents of the definition,  it is now worked
		on to produce the full function.
		
		In general, defn takes three arguments:
          1.  the name of the function being defined
          2.  the argument aliases to use, referenced within the function definition..
          3.  the function definition.
	 --->
    <cffunction name="evaluateTree">
        <cfset var symbolLine = "">
        <cfset var symbols = ArrayLen(parseSymbols)>
        <cfset var parsedSymbols = StructNew()>
        
        <cfreturn>
        
        <cfif StructKeyExists(url, "debug")>
            <cfoutput>Evaluating the tree!</cfoutput>
            <cfdump var="#parseSymbols#">
        </cfif>

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
        <cfif left(fnArgs, 4) IS ":sym">
            <cfset keyName = Right(fnArgs, Len(fnArgs)-1)>
            <cfif StructKeyExists(parseSymbols, keyName)>
                <cfset sub = parseSymbols[keyName]>
                <cfif sub[2] IS "ARRAY">
                    <cfset content.args = ListToArray(sub[1], " ")>
                </cfif>
            </cfif>
        <cfelse>
            <cfset content.args = ListToArray(fnArgs, " ")>
        </cfif>
        
        <!--- establish the function body --->
        <cfset fnBody = ListGetAt(symbolLine, 3, " ")>
        <cfset content.body = CreateObject("component", "List").init(fnBody)>
        
        <!--- then init() the UserFunc --->
        <cfset variables[fnName].init(content, this)>
        <cfdump var="#variables[fnName]#" label="function...">
		<cfdump var="#content#" label="CONTENT (defn)">
        <cfdump var="#variables[fnName].getContents()#" label="getContents() (defn)">
        
        <cfreturn variables[fnName]>
    </cffunction>
    
    <cffunction name="run">
		<cfset var main = variables.parseSymbols[1][1]>
        <cfset var func = createObject("component", "UserFunc")>
        <cfset var ignore = "1">
        <cfset var functionBody = ArrayNew(1)>
        <cfset var functionContents = StructNew()>
        
        <cfif ListLen(main, " ") EQ 3>
            <cfset functionName = ListGetAt(main, 1, " ")>
            
            <!--- the arguments should be referenced by the second term --->
            <cfset sym = ListGetAt(main, 2, " ")>
            <cfset ignore = ListAppend(ignore, sym)>
            <cfset functionArgs = CreateObject("component", "list").init(variables.parseSymbols[Right(sym, Len(sym)-1)][1])>
            
            <!--- construct the body --->
            <cfloop from="1" to="#ArrayLen(parseSymbols)#" index="symbol">
                <cfif NOT ListFind(ignore, symbol)>
                    <cfset ArrayAppend(functionBody, parseSymbols[symbol][1])>
                </cfif>
            </cfloop>
            
            <cfset functionContents.args = functionArgs>
            <cfset functionContents.body = functionBody>
            
            <cfset variables[functionName] = func.init(functionContents, this)>
        <cfelse>
            <cfthrow message="Unable to define a function. DEFN must be called with three args; name, arguments and body">
        </cfif>
        
        <cfreturn variables[functionName]>
    </cffunction>
    
</cfcomponent>