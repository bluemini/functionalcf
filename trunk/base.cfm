<cfset this.name = "funcex">
<cfset this.sessionManagement = true>
<cfparam name="url.debug" default="false">
<cfset request.debug = url.debug>

<cffunction name="$" access="public" output="true">
	
	<cfif url.debug>
		<h3>$:</h3>
		<cfdump var="#arguments#" label="$ arguments">
	</cfif>
	
	<cfset resp = "">
	
	<cfif arrayLen(arguments) LT 1>
		<cfoutput>FunctionalCF - The first argument on the Run function ($) must be a function.</cfoutput>
	<cfelse>
		<cfif structKeyExists(arguments, "arg1")>
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
		
		<cfif isObject(fn)>
			<cfif url.debug><cfoutput>--- called by Object fn ---<br></cfoutput></cfif>
			<cfset resp = fn.run(argumentCollection=newArgs)>
		<cfelseif isCustomFunction(fn)>
			<cfif url.debug><cfoutput>--- called by Custom Function fn ---<br></cfoutput></cfif>
			<cfset resp = fn(argumentCollection=newArgs)>
		<cfelseif isCustomFunction(variables[fn])>
			<cfif url.debug><cfoutput>--- called by String var ---</cfoutput></cfif>
			<cfset tempFunc = variables[fn]>
			<cfset resp = tempFunc(newArgs)>
		<cfelseif isObject(variables[fn])>
			<cfif url.debug><cfoutput>--- calling func.cfc by String var ---</cfoutput></cfif>
			<cfset resp = variables[fn].run(newArgs)>
		<cfelse>
			No function found to run<cfdump var="#variables#">
		</cfif>
		
		<cfif structKeyExists(variables, "resp")><cfoutput>#resp#</cfoutput><br></cfif>
		
		<cfif url.debug>--- $ arguments ---<br>
		<cfdump var="#structKeyArray(arguments)#">
		--- end $ arguments ---<br></cfif>
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


<cffunction name="defn" output="true">
	<cfset var arrKeys = structKeyArray(arguments)>
	<cfset var arrKey = 0>
	<cfset var attr = {}>
	<cfset var arityCount = 1>
	<cfset attr.func = arrayNew(1)>
	<cfset attr.comment = "">
	
	<cfif url.debug><h3>DEFN:</h3>
	<cfdump var="#arguments#" label="arguments"></cfif>
	
	<cfscript>
		if (arrayLen(arguments) LT 2) ;
		
		// parse the arguments and set up the new function definition
		for (i=1; i LTE arrayLen(arrKeys); i++) {
			argName = arguments["arg#i#"];
			// the first argument is always the name of the new function
			if (i EQ 1) {
				attr.name = argName;
				if (url.debug) writeOutput("DEFN: function name: <em>"&attr.name&"</em><br>");
				
			// if the second term is a simple value (string) and not enclosed in square brackets, then this is the comment
			} else if (i EQ 2 AND isSimpleValue(argName) AND 
				(NOT left(argName,1) IS "[" OR NOT right(argName, 1) IS "]")) {
				attr.comment = argName;
				if (url.debug) writeOutput("DEFN: function comment: <em>"&attr.comment&"</em><br>");
			
			// otherwise the second term will start the real definition
			} else if (i GTE 2 AND i LTE 3 AND isSimpleValue(argName) AND 
				left(argName,1) IS "[" AND right(argName, 1) IS "]") {
				attr["argmap"] = argName;
				if (url.debug) writeOutput("DEFN: argument map defined<br>");
				
			// other terms that are arrays are the functional meat of the new function being defined
			} else if (i GT 1 AND isArray(argName)) {
				attr.func[arityCount] = argName;
				arityCount ++;
			}
		}
	</cfscript>

	<cfif url.debug>--- defn attributes ---<br></cfif>
	<cfset variables[attr.name] = createObject("component", "func").init(attr, this)>
	<cfif url.debug>--- end defn attributes ---<br></cfif>
	
	<!--- return notice that the function was created --->
	<cfreturn "> user/#attr.name#">
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