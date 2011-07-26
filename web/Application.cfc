<cfcomponent>
    
    <cfsetting requesttimeout="30">
    <cfinclude template="../core/base.cfm">
    <cfinclude template="./fing.cfm">
    <cfinclude template="./routes.cfm">
    
    <cfinclude template="./attributes.cfm">
    
    <cffunction name="onMissingTemplate">
        <cfargument name="targetPage" type="string" required="true">
        
        <cfset $("fing-handler '#targetPage#'")>
        
        <cfreturn true>
    </cffunction>
    
</cfcomponent>