<cfcomponent>
	
	<!---
	func is an array of function definitions. If there are more than one, then
	the first argument
	--->
	
	<cfset variables.argArray = arrayNew(1)>
	
	<cffunction name="init">
		<cfargument name="name">
		<cfargument name="scope">
		<cfset variables.attr = arguments.name>
		<cfset variables.that = arguments.scope>
		
		<!--- if args were passed in, then store them locally in an array --->
		<cfif structKeyExists(arguments.name, "args")>
			<cfset processArgs(arguments.name.args)>
		</cfif>
		
		<cfif NOT structKeyExists(arguments.name, "func")
			OR NOT isArray(arguments.name.func)
			OR arrayLen(arguments.name.func) LT 1>
			<cfthrow message="A function definition must contain a body.">
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="run">
		<cfset var argMatch = arrayNew(1)>
		<cfset var dynCounter = 1>
		<cfset var newArgs = {}>
		
		<cfif request.debug>--- running <cfoutput>#variables.attr.name#</cfoutput> ---<br>
		<cfdump var="#arguments#" label="FUNC RUN"></cfif>
		<cfoutput>
			
		<!--- find the function definition associated with the number of args passed in --->
		<cfset numArgs = arrayLen(arguments)>
		<cfset funcDecl = 0>
		<cfloop from="1" to="#arrayLen(variables.attr.func)#" index="iDecl">
			<cfif isSimpleValue(variables.attr.func[iDecl][1]) AND listLen(stripDynArg(variables.attr.func[iDecl][1])) EQ numArgs>
				<cfset funcDecl = variables.attr.func[iDecl][2]>
				<cfbreak>
			<cfelseif isObject(variables.attr.func[iDecl][1]) OR isCustomFunction(variables.attr.func[iDecl][1])>
				<cfset funcDecl = variables.attr.func[iDecl]>
				<cfbreak>
			</cfif>
		</cfloop>
		
		<cfif request.debug>
			<cfdump var="#funcDecl#" label="FUNC function definition">
		</cfif>
		<!---
		<cfif isSimpleValue(variables.attr.func[1][1])><cfoutput>#listLen(variables.attr.func[1][1])#, #numArgs#</cfoutput><cfelse>NOPE</cfif>
		--->
		
		<cfif NOT isArray(funcDecl)>Ooops, no function definition found in <cfdump var="#variables.attr.func#"><cfabort></cfif>
		
		<!--- loop over each argument from the definition (variables.attr.args) and
		and add to 
		--->
		
		<cfloop from="2" to="#arrayLen(funcDecl)#" index="iValue">
			<cfset argValue = funcDecl[iValue]>
			<cfif isDynArg(argValue)>
				<!--- the argument needs to be dynamically evaluated --->
				<cfif arrayLen(arguments) GTE dynCounter>
					<cfset arrayAppend(argMatch, arguments[dynCounter])>
					<cfset dynCounter++>
				<cfelse>
					<cfthrow message="Not enough arguments supplied to function">
				</cfif>
			<cfelse>
				<cfset arrayAppend(argMatch, argValue)>
			</cfif>
			<!--- <cfset argMatch[variables.argArray[dynCounter]] = argValue> --->
		</cfloop>
		<cfif request.debug><cfdump var="#argMatch#" label="ARGMATCH"></cfif>
		
		<!--- assemble the array into an argument collection --->
		<cfset newArgs["arg1"] = funcDecl[1]>
		<cfloop from="1" to="#arrayLen(argMatch)#" index="iArgMatch">
			<cfset newArgs["arg#iArgMatch+1#"] = argMatch[iArgMatch]>
		</cfloop>
		
		<cfif request.debug>
			--- Calling our defined function ---<cfdump var="#newArgs#" label="FUNC argumentCollection">
		</cfif>
		<cfset variables.that.$(argumentCollection=newArgs)>
		</cfoutput>
	</cffunction>
	
	<cffunction name="processArgs">
		<cfargument name="argCollection">
		
		<cfset var tempArray = arrayNew(1)>
		
		<cfif isDynArg(arguments.argCollection)>
			<cfset tempArray = listToArray(mid(argCollection,2,len(argCollection)-2))>
		</cfif>
		<cfset variables.argArray = tempArray>
	</cffunction>
	
	<cffunction name="isDynArg">
		<cfargument name="toCheck">
		<cfif left(arguments.toCheck,1) IS "[" AND right(arguments.toCheck,1) IS "]">
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="stripDynArg">
		<cfargument name="toCheck">
		<cfif isDynArg(toCheck)>
			<cfreturn mid(toCheck, 1, len(toCheck)-2)>
		</cfif>
		<cfreturn false>
	</cffunction>

</cfcomponent>