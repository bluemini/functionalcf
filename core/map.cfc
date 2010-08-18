<cfcomponent>
	
	<cfset variables.data = structNew()>

	<!--- creates a map object, it expects a CF struct --->
	<cffunction name="init">
		<cfargument name="datastruct">
		
		<!--- check that the incoming data is a struct --->
		<cfif NOT isArray(arguments.datastruct)>
			<cfthrow message="Unable to define a map given the data provided">
		<cfelseif arrayLen(arguments.datastruct) mod 2 NEQ 0>
			<cfthrow message="Uneven number of attributes in the map initialisation string">
		<cfelse>
			<cfloop from="1" to="#arrayLen(arguments.datastruct)#" index="i" step="2">
				<cfset hashcode = hash(arguments.datastruct[i].tostring())>
				<cfset variables.data[hashcode].key = arguments.datastruct[i]>
				<cfset variables.data[hashcode].data = arguments.datastruct[i+1]>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="run">
		<cfset var hashcode = "">
		<cfif structKeyExists(arguments, "arg1")>
			<cfset hashcode = hash(arguments["arg1"].tostring())>
		</cfif>
		<!--- try and locate the key and return the value --->
		<cfif structKeyExists(variables.data, hashcode)>
			<cfreturn variables.data[hashcode].data>
		<cfelse>
			<cfreturn "nil">
		</cfif>
	</cffunction>
	
	<cffunction name="getData"><cfreturn variables.data></cffunction>
	
	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfargument name="methodName" required="true">
		<cfset var searchForKey = structFind(variables.data, arguments.methodName)>
		<cfdump var="#searchForKey#"><cfabort>
	</cffunction>

</cfcomponent>