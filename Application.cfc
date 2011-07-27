<cfcomponent>
    
    <cfsetting requesttimeout="30" showdebugoutput="false">
    
	<cffunction name="onRequestStart">
		<cfargument name="targetPage" type="string" required="true">
		
        <cfinclude template="./nav/style.cfm">

        <cfinclude template="./core/base.cfm">
        <cfinclude template="./core/cfnCore.cfm">
    
        <cfset request.time = GetTickCount()>
		<cfinclude template="#arguments.targetPage#">
        <cfset request.time = GetTickCount() - request.Time>
        
		<cfinclude template="./nav/paginate.cfm">
		<cfabort>
	</cffunction>
    
</cfcomponent>