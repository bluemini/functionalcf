<cfset this.name = "funcex">
<cfset this.sessionManagement = true>
<cfparam name="url.debug" default="false">
<cfset request.debug = url.debug>

<cfset request.coreFunctions = "defn lt if">

<cffunction name="$" access="public" output="true">
    
    <cfif url.debug>
		<h3>$:</h3>
		<cfdump var="#arguments#" label="$ arguments">
	</cfif>
	
	<cfset resp = "">
	
	<cfif arrayLen(arguments) NEQ 1 OR NOT IsSimpleValue(arguments[1])>
		<cfoutput>FunctionalCF - The argument to $() MUST be a string.</cfoutput>
	<cfelse>
    
        <cfset input = arguments[1]>
        
        <!--- Since FunctionCF is drawing on the Lisp idea, where even the program code is a list,
        we need to create a list from the body text --->
        <cfset baseList = createObject("component", "List").init(input)>
        
        <!--- run the list, which will perform the primary top level function --->
        <cfset variables = baseList.run(variables)>
        
        <cfdump var="#variables#">
        
        <cfif url.debug>
            <cfdump var="#out#" label="out">
        </cfif>
        
        <cfset result = out.run()>
        
        <cftry><cfoutput>#result#</cfoutput><cfcatch></cfcatch></cftry>
    
		<!--- <cfif structKeyExists(arguments, "arg1")>
			<cfset fn = arguments["arg1"]>
		<cfelse>
			<cfset fn = arguments[1]>
		</cfif>
		
		<!--- copy the remaining arguments to a new struct --->
		<cfset newArgs = structNew()>
		<cfset newArgName = 1>
		<cfset arrArgKeys = structKeyArray(arguments)>
		<cfloop from="2" to="#arrayLen(arrArgKeys)#" index="argumentName">
			<cfif structKeyExists(arguments, "arg#argumentName#")>
				<cfset newArgs["arg"&(argumentName-1)] = arguments["arg#argumentName#"]>
			<cfelse>
				<cfset newArgs["arg"&(argumentName-1)] = arguments[argumentName]>
			</cfif>
		</cfloop>
		<cfif url.debug><cfdump var="#newArgs#" label="$ newArgs"></cfif>
		

		
		<cfif structKeyExists(variables, "resp")><cfoutput>#resp#</cfoutput><br></cfif>
		
		<cfif url.debug>--- $ arguments ---<br>
		<cfdump var="#structKeyArray(arguments)#">
		--- end $ arguments ---<br></cfif> --->
	</cfif>
</cffunction>

<cffunction name="C" access="public" output="true">
	<cfif arrayLen(arguments) NEQ 1>
		<cfthrow message="funcex requires only one parameters">
	</cfif>
	
	<cfset parsedRE = REFind("(([A-Za-z0-9])*\w)", arguments[1], 1, true)>
	<cfdump var="#parsedRE#">
	<cfloop from="1" to="#arrayLen(parsedRE.pos)#" index="i">
		<cfoutput>#mid(arguments[1], parsedRE.pos[i], parsedRE.len[i])#<br></cfoutput>
	</cfloop>
	<cfabort>
	
	<cfset fn = arguments[1]>
	<cfset arrayDeleteAt(arguments, 1)>
	<cfset newArgs = structCopy(arguments)>
	--- callin fn ---<br>
	<cfif isObject(fn)>
		<cfset fn.run(argumentCollection=newArgs)>
	<cfelseif isCustomFunction(fn)>
		<cfset fn(argumentCollection=newArgs)>
	</cfif>
	
	--- $ arguments ---
	<cfdump var="#arguments#">
	--- end $ arguments ---<br>
</cffunction>

<cffunction name="def" output="true">
	<cfset var arrKeys = structKeyArray(arguments)>
	<cfset var arrKey = 0>
	<cfset var attr = {}>
	<cfset var arityCount = 1>
	<cfset attr.func = arrayNew(1)>
	<cfset attr.comment = "">
	
	<cfif url.debug><h3>DEF:</h3>
	<cfdump var="#arguments#" label="DEF arguments"></cfif>
	
	<cfscript>
		if (arrayLen(arguments) LT 2) ;
		
		// parse the arguments and set up the new function definition
		for (i=1; i LTE arrayLen(arrKeys); i++) {
			argName = arguments["arg#i#"];
			// the first argument is always the name of the new function
			if (i EQ 1) {
				attr.name = argName;
				if (url.debug) writeOutput("DEFN: function name: <em>"&attr.name&"</em><br>");
				
			// if the second term is a struct then we are creating a MAP
			} else if (i EQ 2 AND isArray(argName)) {
				temp = createObject("component", "map");
				temp.init(argName);
			
			// otherwise the second term will start the real definition
			} else if (i GTE 2 AND i LTE 3 AND isSimpleValue(argName) AND 
				left(argName,1) IS "[" AND right(argName, 1) IS "]") {
				temp = createObject("component", "map");
				temp.init(argName);
				// attr["argmap"] = argName;
				// if (url.debug) writeOutput("DEFN: argument map defined<br>");
				
			// other terms that are arrays are the functional meat of the new function being defined
			} else if (i GT 1 AND isArray(argName)) {
				attr.func[arityCount] = argName;
				arityCount ++;
			}
		}
	</cfscript>
	
	<cfset variables[attr.name] = temp>

	<!--- return notice that the function was created --->
	<cfreturn "> user/#attr.name#">
</cffunction>

<cffunction name="kw">
	<cfargument name="keywordValue" type="string">
	<cfreturn createObject("component", "keyword").init(arguments.keywordValue)>
</cffunction>

<cffunction name="println" output="true">
	<cfset var numberOfArgs = arrayLen(arguments)>
	<cfset var out = "">
	<cfset var argumentValue = "">
	
	<cfif url.debug><h3>PRINTLN:</h3></cfif>
	
	<cfif arrayLen(structKeyArray(arguments)) EQ 1
		AND isArray(arguments[1])>
		<cfset arg = arguments[1]>
	</cfif>

	<cfif url.debug>--- calling println ---<br>
	<cfdump var="#arguments#" label="PRINTLN arguments"></cfif>
	
	<cfloop from="1" to="#numberOfArgs#" index="i">
		<cfset argumentValue = arguments["arg#i#"]>
		<cfif isSimpleValue(argumentValue)><cfset out &= argumentValue></cfif>
	</cfloop>
	
	<cfreturn out>
</cffunction>

<cffunction name="add" output="false">
	<cfset var arg = arguments>
	<cfset var sum = 0>
	
	<cfif arrayLen(structKeyArray(arguments)) EQ 1
		AND isArray(arguments[1])>
		<cfset arg = arguments[1]>
	</cfif>

	<cfif url.debug>--- calling ADD ---<br>
	<cfdump var="#arg#" label="+ args"></cfif>
	<cfloop array="#arg#" index="i">
		<cfif isNumeric(i)><cfset sum += i></cfif>
	</cfloop>
	<cfreturn sum>
</cffunction>





<cffunction name="onRequest" returntype="void">
	<cfargument name="targetpage" type="any" required="true">
	<cfinclude template="#arguments.targetpage#">
</cffunction>

<!---
<cffunction name="func" access="public" hint="represents any new function">
	--- func arguments ---
	<cfdump var="#arguments#">
	--- end func arguments ---<br>
	<cfreturn this>
</cffunction>
--->

<cfset if = createObject("component", "functionalCF.core.func")>
<cfset lGT = createObject("component", "functionalCF.core.func")>
