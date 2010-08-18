<cfcomponent>
	
	<cfset variables.data = structNew()>

	<!--- creates a map object, it expects a CF struct --->
	<cffunction name="init">
	</cffunction>
	
	<!--- when running a nil it simply returns itself. --->
	<cffunction name="run">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="tostring">
		<cfreturn "nil">
	</cffunction>
	
</cfcomponent>