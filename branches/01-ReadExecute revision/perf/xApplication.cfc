<cfcomponent>
    
    <cfsetting requesttimeout="30">
    
	<cfinclude template="../core/base.cfm">
	
	<cffunction name="onRequestStart">
		<cfargument name="targetPage" type="string" required="true">
		<cfinclude template="#arguments.targetPage#">
		<cfabort>
	</cffunction>
    
</cfcomponent>