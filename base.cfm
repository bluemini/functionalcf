<cfset this.name = "funcex">
<cfset this.sessionManagement = true>

<cffunction name="$" access="public" output="true">
	<cfset resp = "">
	<cfsetting enablecfoutputonly="true">
	
	<cfif arrayLen(arguments) LT 2>
		<cfthrow message="funcex requires at least two parameters">
	</cfif>
	<cfset fn = arguments[1]>
	<cfset arrayDeleteAt(arguments, 1)>
	--- callin fn ---<br>
	<cfif isObject(fn)>
		HERE
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


<cffunction name="defn" output="false">
	<cfdump var="#arguments#" label="DEF ARGS">
	<cfscript>
		var arrKeys = structKeyArray(arguments);
		var arrKey = 0;
		var attr = {};
		attr.comment = "";
		
		if (arrayLen(arguments) LT 2) ;
		
		// parse the arguments and set up the new function definition
		for (i=1; i LTE arrayLen(arrKeys); i++) {
			arrKey = arrKeys[i];
			// the first argument is always the name of the new function
			if (i EQ 1) {
				attr.name = arguments[arrKey];
				writeOutput("DEFN: function name: "&attr.name&"<br>");
			}
			
			if (isArray(arguments[arrKey]) AND structKeyExists(attr, "args")) {
				attr.func = arguments[arrKey];
			} else if (left(arguments[arrKey],1) IS "[" AND right(arguments[arrKey],1) IS "]") {
				attr.args = arguments[arrKey];
			} else if (NOT structKeyExists(attr, "args")) {
				attr.comment = arguments[arrKey]; // nice side effect is that the comment becomes function name when no comment is specified
			}
		}
	</cfscript>
	--- defn attributes ---
	<cfset tempFunc = createObject("component", "func")>
	<cfset tempFunc.init(attr, this)>
	<cfset variables[attr.name] = tempFunc>
	<cfdump var="#attr#">
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
