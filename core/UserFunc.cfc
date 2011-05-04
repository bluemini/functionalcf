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
        
        <cfset super.init(this.name, arguments.contents, arguments.scope)>
        
        <cfif url.debug>
            <strong>UserFunc</strong>.init()<br>
            contents: #variables.contents.toString()#<br>
        </cfif>
        
        <!--- we need to associate the arg values provided in contents, with those defined in setup --->
        <cfset variables.argMap = StructNew()>
        <!--- TODO: replace this iteration with a seq, once the codes written! --->
        <cfloop condition="args.length() GT 0">
            <cfset arg = args.first().data>
			<cfset value = variables.contents.first()>
			<!--- check if the value is actually a reference to a var... --->
            <cfif StructKeyExists(variables.scope, value.data)>
                <cfset value = variables.scope[value.data]>
            <cfelse>
                <cfoutput>ARGS: #args.toString()#</cfoutput>
                <cfthrow message="unable to bind a value to #value.data#">
            </cfif>
            <cfset variables.argMap[arg] = value>
            <cfset args = args.rest()>
        </cfloop>
        
        <cfif url.debug or true>
            <cfdump var="#argMap#" label="argMap (UserFunc/init)">
        </cfif>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true" hint="contains previous bindings from an enclosing function">
        
        <cfif url.debug>
            <strong>UserFunc</strong>.run()<br>
            <cfoutput>FunctionDetail.ARGS: #variables.functionDetail.args.toString()#<br></cfoutput>
            <cfoutput>FunctionDetail.BODY: #variables.functionDetail.body.toString()#<br></cfoutput>
            <cfoutput>#variables.functionDetail.body.rest().toString()#<br></cfoutput>
        </cfif>
		
		<cfif url.explain>
			Running UserFunc whose:<br>
			<cfoutput>ARGS: #variables.functionDetail.args.toString()#<br>
			BODY: #variables.functionDetail.body.toString()# (type: #variables.functionDetail.body.getType()#)<br></cfoutput>
		</cfif>
        
        <!--- run the body of the function, passing in the argMap, so that calls can bind to vars as needed
        <cfif variables.functionDetail.body.rest().first().getType() IS "List">
            <cfif url.debug OR url.explain>
                <cfoutput>Running the rest() of the function body<br></cfoutput>
            </cfif>

    		<cfset resp = variables.functionDetail.body.rest().first().run(bindMap, variables.scope)>
            
            <cfif url.debug OR url.explain>
                <cfoutput>Running the rest() of the function body returned: #resp.toString()#<br></cfoutput>
            </cfif>
        </cfif> --->
        
        <cfset resp = variables.functionDetail.body.run(variables.argMap, variables.scope)>
        
        <cfreturn resp>
    </cffunction>
    
    <cffunction name="getContents">
        <cfreturn variables.contents>
    </cffunction>

</cfcomponent>