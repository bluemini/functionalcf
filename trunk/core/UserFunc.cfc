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
        
        <!--- we need to associate the arg values provided in contents, with those defined in setup --->
        <cfset variables.argMap = StructNew()>
        <!--- TODO: replace this iteration with a seq, once the codes written! --->
        <cfset arg1 = variables.functionDetail.args.first().data>
        <cfset variables.argMap[arg1] = variables.contents.first().data>
        
        <cfdump var="#variables.argMap#" label="argMap (UserFunc/init)">
        
        <cfset super.init(this.name, arguments.contents, arguments.scope)>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
        <cfif url.debug>
            <cfdump var="#variables.functionDetail#" label="functionDetail (UserFunc/run)">
        </cfif>
        
        <!--- loop over the body of the function, if any arg is referenced by name, then replace it's 
        reference with the appropriate value from the argMap. If a nested function is found (:x) then
        put the current function on the stack and resolve the nested function first --->
        <cfset lineBody = variables.functionDetail.body>
        
        <cfif url.debug>
            <cfdump var="#variables.functionDetail.args._getData()#" label="function args array (UserFunc/run)">
            <cfdump var="#variables.functionDetail.body._getData()#" label="function body array (UserFunc/run)">
        </cfif>
		
		<!--- TODO: Bind the args passed in during init() with the holders in the function body --->
        <!---
		<cfset bindTo(lineBody)>
        --->
        
		<cfset resp = lineBody.run(variables.argMap)>
        
        <cfreturn resp>
    </cffunction>
    
    <cffunction name="getContents">
        <cfreturn variables.contents>
    </cffunction>

</cfcomponent>