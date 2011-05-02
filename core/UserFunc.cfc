<cfcomponent extends="func" implements="IRunnable">
    
    <cffunction name="setup">
        <cfargument name="functionDetail">
        <cfset variables.functionDetail = arguments.functionDetail>
        <cfreturn this>
    </cffunction>

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset var arg = "">
        <cfset var args = variables.functionDetail.args>
        
        <cfset variables.contents = arguments.contents>
        <cfset variables.scope = arguments.scope>
        
        <cfif url.debug>
            <cfdump var="#variables.contents#" label="contents (userFunc/init)">
        </cfif>
        
        <!--- we need to associate the arg values provided in contents, with those defined in setup --->
        <cfset variables.argMap = StructNew()>
        <!--- TODO: replace this iteration with a seq, once the codes written! --->
        <cfloop condition="args.length() GT 0">
            <cfset arg = args.first().data>
            <cfset variables.argMap[arg] = variables.contents.first().data>
            <cfset args = args.rest()>
        </cfloop>
        
        <cfif url.debug>
            <cfdump var="#variables.argMap#" label="argMap (UserFunc/init)">
        </cfif>
        
        <cfset super.init(this.name, arguments.contents, arguments.scope)>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
        <cfif url.debug>
            <cfdump var="#variables.functionDetail#" label="functionDetail (UserFunc/run)">
        </cfif>
        
        <cfif url.debug>
            <cfdump var="#variables.functionDetail.args._getData()#" label="function args array (UserFunc/run)">
            <cfdump var="#variables.functionDetail.body._getData()#" label="function body array (UserFunc/run)">
        </cfif>
		
        <!--- run the body of the function, passing in the argMap, so that calls can bind to vars as needed --->
		<cfset resp = variables.functionDetail.body.run(variables.argMap)>
        
        <cfreturn resp>
    </cffunction>
    
    <cffunction name="getContents">
        <cfreturn variables.contents>
    </cffunction>

</cfcomponent>