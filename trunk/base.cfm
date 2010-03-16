<cfset this.name = "funcex">
<cfset this.sessionManagement = true>

<cffunction name="$" access="public" output="true">
	<cfset resp = "">
	<cfsetting enablecfoutputonly="true">
	
	<cfif arrayLen(arguments) LT 1>
		<cfoutput>FunctionalCF - The first argument on the Run function ($) must be a function.</cfoutput>
	<cfelse>
		<cfset fn = arguments[1]>
		<cfset arrayDeleteAt(arguments, 1)>
		--- callin fn ---<br>
		<cfif isObject(fn)>
			<cfset resp = fn.run(argumentCollection=arguments[1])>
		<cfelseif isCustomFunction(fn)>
			<cfset resp = fn(argumentCollection=arguments)>
		<cfelseif isCustomFunction(variables[fn])>
			<cfset resp = variables[fn](arguments)>
		</cfif>
		
		<cfif structKeyExists(variables, "resp")><cfoutput>#resp#</cfoutput></cfif>
		
		--- $ arguments ---
		<cfdump var="#arguments#">
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
	<cfdump var="#arguments#" label="DEF ARGS">
	<cfscript>
		var arrKeys = structKeyArray(arguments);
		var arrKey = 0;
		var attr = {};
		var arityCount = 1;
		attr.func = arrayNew(1);
		attr.comment = "";
		
		if (arrayLen(arguments) LT 2) ;
		
		// parse the arguments and set up the new function definition
		for (i=1; i LTE arrayLen(arrKeys); i++) {
			arrKey = arrKeys[i];
			argName = arguments[arrKey];
			// the first argument is always the name of the new function
			if (i EQ 1) {
				attr.name = argName;
				writeOutput("DEFN: function name: "&attr.name&"<br>");
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
	<cfdump var="#attr#">

	--- defn attributes ---
	<cfset tempFunc = createObject("component", "func")>
	<cfset tempFunc.init(attr, this)>
	<cfset variables[attr.name] = tempFunc>
	--- end defn attributes ---<br>
</cffunction>

<cffunction name="println" output="false">
	<cfset var arg = arguments>
	<cfset var out = "">
	
	<cfif arrayLen(structKeyArray(arguments)) EQ 1
		AND isArray(arguments[1])>
		--- YEP
		<cfset arg = arguments[1]>
	</cfif>

	--- calling println ---<br>
	<cfdump var="#arguments#" label="println args">
	<cfloop array="#arg#" index="i">
		<cfif isSimpleValue(i)><cfset out &= i></cfif>
	</cfloop>
	
	<cfreturn out>
</cffunction>

<cffunction name="+" output="false">
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
