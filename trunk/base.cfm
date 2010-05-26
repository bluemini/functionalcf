<cfset this.name = "funcex">
<cfset this.sessionManagement = true>

<cffunction name="$" access="public" output="true">
	<cfset resp = "">
	
	<cfif arrayLen(arguments) LT 1>
		<cfoutput>FunctionalCF - The first argument on the Run function ($) must be a function.</cfoutput>
	<cfelse>
		<cfset fn = arguments[1]>
		
		<!--- copy the remaining arguments to a new struct --->
		<cfset newArgs = structNew()>
		<cfset newArgName = 1>
		<cfset arrArgKeys = structKeyArray(arguments)>
		<cfloop from="2" to="#arrayLen(arrArgKeys)#" index="argumentName">
			<cfset newArgs["arg"&(argumentName-1)]=arguments[argumentName]>
		</cfloop>
		<cfdump var="#newArgs#" label="$ newArgs">
		
		--- calling fn ---<br>
		<cfif isObject(fn)>
			<cfoutput>--- called by Object fn ---<br></cfoutput>
			<cfset resp = fn.run(argumentCollection=newArgs)>
		<cfelseif isCustomFunction(fn)>
			<cfoutput>--- called by Custom Function fn ---<br></cfoutput>
			<cfset resp = fn(argumentCollection=newArgs)>
		<cfelseif isCustomFunction(variables[fn])>
			<cfoutput>--- called by String var ---</cfoutput>
			<cfset tempFunc = variables[fn]>
			<cfset resp = tempFunc(newArgs)>
		<cfelseif isObject(variables[fn])>
			<cfoutput>--- calling func.cfc by String var ---</cfoutput>
			<cfset resp = variables[fn].run(newArgs)>
		<cfelse>
			No function found to run<cfdump var="#variables#">
		</cfif>
		
		<cfif structKeyExists(variables, "resp")><cfoutput>#resp#</cfoutput><br></cfif>
		
		--- $ arguments ---<br>
		<cfdump var="#structKeyArray(arguments)#">
		--- end $ arguments ---<br>
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
	
	<cfdump var="#arguments#" label="arguments">
	<cfdump var="#arrKeys#" label="argument keys">
	
	<cfscript>
		if (arrayLen(arguments) LT 2) ;
		
		// parse the arguments and set up the new function definition
		for (i=1; i LTE arrayLen(arrKeys); i++) {
			arrKey = arrKeys["#i#"];
			argName = arguments[arrKey];
			// the first argument is always the name of the new function
			if (i EQ 1) {
				attr.name = argName;
				writeOutput(argName);
				// writeOutput("DEFN: function name: "&attr.name&"<br>");
			} else if (i EQ 2 AND isSimpleValue(argName) AND 
				(NOT left(argName,1) IS "[" OR NOT right(argName, 1) IS "]")) {
				attr.comment = argName;
				writeOutput("DEFN: function comment: " );
			} else if (i GTE 2 AND i LTE 3 AND isSimpleValue(argName) AND 
				left(argName,1) IS "[" AND right(argName, 1) IS "]") {
				attr["argmap"] = argName;
				writeOutput("DEFN: argument map defined: " );
			} else if (i GT 1 AND isArray(argName)) {
				attr.func[arityCount] = argName;
				arityCount ++;
			}
		}
	</cfscript>

	--- defn attributes ---
	<cfset variables[attr.name] = createObject("component", "func").init(attr, this)>
	--- end defn attributes ---<br>
</cffunction>

<cffunction name="println" output="false">
	<cfset var arg = arguments>
	<cfset var out = "">
	
	<cfif arrayLen(structKeyArray(arguments)) EQ 1
		AND isArray(arguments[1])>
		--- YEP<br>
		<cfset arg = arguments[1]>
	</cfif>

	--- calling println ---<br>
	
	<cfloop array="#arg#" index="i">
		<cfif isSimpleValue(i)><cfset out &= i></cfif>
	</cfloop>
	
	<cfreturn out>
</cffunction>

<cffunction name="add" output="false">
	<cfset var arg = arguments>
	<cfset var sum = 0>
	
	<cfif arrayLen(structKeyArray(arguments)) EQ 1
		AND isArray(arguments[1])>
		--- YEP
		<cfset arg = arguments[1]>
	</cfif>

	--- calling + ---<br>
	<cfdump var="#arg#" label="+ args">
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
