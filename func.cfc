<cfcomponent>
	
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
		
		--- running <cfoutput>#variables.attr.name#</cfoutput> ---<br>
		<cfdump var="#arguments#" label="FUNC RUN">
		<cfoutput>
			
		<!--- find the function definition associated with the number of args passed in --->
		<cfset numArgs = arrayLen(arguments)>
		<cfset funcDecl = 0>
		<cfloop from="1" to="#arrayLen(variables.attr.func)#" index="iDecl">
			<cfif isSimpleValue(variables.attr.func[iDecl][1]) AND listLen(variables.attr.func[iDecl][1]) EQ numArgs>
				<cfset >
				<cfset funcDecl = variables.attr.func[iDecl]>
				<cfbreak>
			<cfelseif isObject(variables.attr.func[iDecl][1])>
				<cfset funcDecl = >
			</cfif>
		</cfloop>
		
		<!--- loop over each argument from the definition (variables.attr.args) and
		and add to 
		--->
		
		<cfloop from="2" to="#arrayLen(variables.attr.func)#" index="iValue">
			<cfset argValue = variables.attr.func[iValue]>
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
		<cfdump var="#argMatch#" label="ARGMATCH">
		
		<!---
				<cfset argValue = "">
				--- #UCASE(variables.attr.name)#: variable[#iAttr#] #argName#<br>
		--->
		
		--- Calling our defined function ---<br>
		<cfset variables.that.$(variables.that.println, argMatch)>
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

</cfcomponent>