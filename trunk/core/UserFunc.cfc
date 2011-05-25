<cfcomponent extends="func" implements="IRunnable">
    
    <cffunction name="setup">
        <cfargument name="functionDetail">
        <cfset variables.functionDetail = arguments.functionDetail>
        <cfreturn this>
    </cffunction>

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="inputData" type="any">
        <cfargument name="scope" type="any">
        
        <cfset var arg = "">
        <cfset var args = variables.functionDetail.args>
        <cfset var argCount = 1>
        
        <cfset super.init(this.name, arguments.inputData, arguments.scope)>
        
        <cfif url.debug>
            <strong>UserFunc</strong>.init()<br>
            inputData: #variables.inputData.toString()# /#variables.inputData.getType()#<br>
            args: #args.toString()# /#args.getType()#<br>
        </cfif>
        
        <!--- we need to associate the arg values provided in contents, with those defined in setup --->
        <cfset variables.argMap = StructNew()>
        
        <!--- TODO: replace this iteration with a seq, once the codes written! --->
        <cfif args.length() NEQ variables.inputData.length()>
            <cfthrow message="unable to merge provided arguments with those required. Length mismatch">
        </cfif>
        
        <cfif url.debug or true>
            <cfdump var="#argMap#" label="argMap (UserFunc/init)">
        </cfif>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true" hint="contains previous bindings from an enclosing function">
        
        <cfset var handle = "">
        <cfset var data = variables.inputData>
        
        <cfif url.debug OR url.explain>
            <strong>UserFunc</strong>.run()<br>
            <cfoutput>FunctionDetail.ARGS: #variables.functionDetail.args.toString()# /#variables.functionDetail.args.getType()#<br></cfoutput>
            <cfoutput>FunctionDetail.BODY: #variables.functionDetail.body.toString()# /#variables.functionDetail.body.getType()#<br></cfoutput>
        </cfif>
        
        <!--- blend the bindMap data, which contains the real values, with handlers specified in args --->
        <cfloop array="#variables.functionDetail.args._getData()#" index="handle">
            <cfif url.explain>
                <cfoutput>handle:#handle.toString()#<br>
                data.first(): #data.first().toString()#<br></cfoutput>
            </cfif>
            
            <!--- if the refernced var is in global scope (variables) assign it --->
            <cfif data.first().getType() IS "list">
                <cfoutput>Running #data.first().toString()#<br></cfoutput>
                <cfset argMap[handle.toString()] = data.first().run(bindMap, variables.scope)>
            <cfelseif StructKeyExists(variables.scope, data.first().toString())>
                <cfset argMap[handle.toString()] = variables.scope[data.first().toString()]>
            <cfelseif StructKeyExists(bindMap, data.first().toString())>
                <cfset argMap[handle.toString()] = bindMap[data.first().toString()]>
            <cfelse>
                DANG!
                <cfdump var="#bindMap#">
                <cfdump var="#variables.scope#">
                <cfabort>
            </cfif>
            <cfset data = data.rest()>
        </cfloop>
        
        <cfif url.explain>
            <cfdump var="#bindMap#" label="bindMap (UserFunc/run)">
            <cfdump var="#argMap#" label="argMap (UserFunc/run)">
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
        <cfreturn variables.inputData>
    </cffunction>

</cfcomponent>