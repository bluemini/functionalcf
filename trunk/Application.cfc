<cfcomponent>
    
    <cfsetting requesttimeout="30">
    
	<cfinclude template="./core/base.cfm">
    <cfinclude template="./core/cfnCore.cfm">
	
	<cffunction name="onRequestStart">
		<cfargument name="targetPage" type="string" required="true">
		
		<cfinclude template="./nav/style.cfm">
        <cfset request.time = GetTickCount()>
		<cfinclude template="#arguments.targetPage#">
        <cfset request.time = GetTickCount() - Time>
		<cfinclude template="./nav/paginate.cfm">
		<cfabort>
	</cffunction>
    
</cfcomponent>