<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset variables.contents = arguments.contents>
        <cfset variables.scope = arguments.scope>
        
        <cfdump var="#variables.contents#">
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        Running UserFunc...<br>
        <cfset CreateObject("component", "list").init(variables.contents.body["sym3"][1]).run()>
        <cfdump var="#variables.contents#"><cfabort>
        
        <cfset super.run()>
    </cffunction>
    
    <cffunction name="getContents">
        <cfreturn variables.contents>
    </cffunction>

</cfcomponent>