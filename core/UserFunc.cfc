<cfcomponent extends="func" implements="IRunnable">
    
    <cffunction name="setup">
        <cfargument name="functionDetail">
        <cfset variables.functionDetail = arguments.functionDetail>
        <cfreturn this>
    </cffunction>

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset variables.contents = arguments.contents>
        <cfset variables.scope = arguments.scope>
        
        <cfif url.debug>
            <cfdump var="#variables.contents#" label="contents (userFunc/init)">
        </cfif>
        
        <cfset super.init(this.name, arguments.contents, arguments.scope)>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">

        <cfif url.debug>
            <cfdump var="#variables.functionDetail#" label="functionDetail (UserFunc/run)">
        </cfif>
        
        <!--- loop over the body of the function, if any arg is referenced by name, then replace it's 
        reference with the appropriate value from the argMap. If a nested function is found (:x) then
        put the current function on the stack and resolve the nested function first --->
        <cfset lineBody = variables.functionDetail.body[1]>
        <cfset lineBody = ListSetAt(lineBody, ListFind(lineBody, "num", " "), variables.contents.first(), " ")>
        <cfset resp = CreateObject("component", "list").init(lineBody).run()>
        
        <cfreturn resp>
    </cffunction>
    
    <cffunction name="getContents">
        <cfreturn variables.contents>
    </cffunction>

</cfcomponent>