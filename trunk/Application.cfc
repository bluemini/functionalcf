<cfcomponent>
	<cfinclude template="./core/base.cfm">
	
	<cffunction name="onRequestStart">
		<cfargument name="targetPage" type="string" required="true">
		
		<cfinclude template="./nav/style.cfm">
		<cfinclude template="#arguments.targetPage#">
		<cfinclude template="./nav/paginate.cfm">
		<cfabort>
	</cffunction>
</cfcomponent>