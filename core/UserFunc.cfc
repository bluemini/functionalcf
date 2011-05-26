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
        <cfset var argTokens = 0>
        
        <cfset super.init(this.name, arguments.inputData, arguments.scope)>
        
        <cfif url.debug>
            <strong>UserFunc</strong>.init()<br>
            inputData: #variables.inputData.toString()# /#variables.inputData.getType()#<br>
            args: #args.toString()# /#args.getType()#<br>
        </cfif>
        
        <!--- we need to associate the arg values provided in contents, with those defined in setup --->
        <cfset variables.argMap = StructNew()>
        
        <!---
        <!--- count how many of the inputData fields are tokens that need resolving --->
        <cfloop array="#variables.inputData._getData()#" index="type">
            <cfif type.getType() IS "Token" OR type.getType() IS "String"><cfset argTokens++></cfif>
        </cfloop>
        
        <!--- TODO: replace this iteration with a seq, once the codes written! --->
        <cfif args.length() GT argTokens>
            <cfdump var="#args._getData()#" label="args">
            <cfdump var="#variables.inputData._getData()#" label="inputData">
            <cfthrow message="unable to merge provided arguments (#args.length()#) with those required (#argTokens#). Length mismatch">
        </cfif>
        
        <cfif url.debug>
            <cfdump var="#argMap#" label="argMap (UserFunc/init)">
        </cfif>
        --->
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true" hint="contains previous bindings from an enclosing function">
        
        <cfset var handle = "">
        <cfset var data = variables.inputData>
        <cfset var dataFirst = "">
        
        <cfif url.debug OR url.explain>
            <strong>UserFunc</strong>.run()<br>
            <cfoutput>FunctionDetail.ARGS: #variables.functionDetail.args.toString()# /#variables.functionDetail.args.getType()#<br></cfoutput>
            <cfoutput>FunctionDetail.BODY: #variables.functionDetail.body.toString()# /#variables.functionDetail.body.getType()#<br></cfoutput>
        </cfif>
        
        <!--- blend the bindMap data, which contains the real values, with handlers specified in args --->
        <cfloop array="#variables.functionDetail.args._getData()#" index="handle">
            
            <cfset dataFirst = data.first()>
            
            <cfif url.explain>
                <cfoutput>handle:#handle.toString()#<br>
                data.first(): #dataFirst.toString()#<br></cfoutput>
            </cfif>
            
            <cftry>
                <cfset n = dataFirst.getType()>
                <cfcatch>
                    <cfoutput>FunctionDetail.ARGS: #variables.functionDetail.args.toString()# /#variables.functionDetail.args.getType()#<br></cfoutput>
                    <cfoutput>FunctionDetail.BODY: #variables.functionDetail.body.toString()# /#variables.functionDetail.body.getType()#<br></cfoutput>
                    <cfdump var="#data.toString()#">
                    <cfdump var="#dataFirst#">
                    <cfabort>
                </cfcatch>
            </cftry>
            
            <!--- if the refernced var is in global scope (variables) assign it --->
            <cfif dataFirst.getType() IS "list">
                <cfif url.explain>
                    <cfoutput>Running #dataFirst.toString()#<br></cfoutput>
                </cfif>
                <!--- the use of an intermediary variable seemed to be necessary for Railo to store the correct value --->
                <cfset resp = dataFirst.run(bindMap, variables.scope)>
                <cfif url.explain>
                    <cfoutput>returned #resp.toString()#</cfoutput><br>
                </cfif>
                <cfset argMap[handle.toString()] = resp>
            <cfelseif StructKeyExists(variables.scope, dataFirst.toString())>
                <cfset argMap[handle.toString()] = variables.scope[data.first().toString()]>
            <cfelseif StructKeyExists(bindMap, dataFirst.toString())>
                <cfset argMap[handle.toString()] = bindMap[data.first().toString()]>
            <cfelseif data.first().getType() IS "String">
                <cfset argMap[handle.toString()] = dataFirst.toString()>
            <cfelse>
                DANG! trying to resolve <cfoutput>#dataFirst.toString()# without success</cfoutput>
                <!--- <cfdump var="#bindMap#">
                <cfdump var="#variables.scope#">
                <cfthrow> --->
            </cfif>
            <cfset data = data.rest()>
        </cfloop>
        
        <cfif url.explain>
            <cfdump var="#bindMap#" label="bindMap (UserFunc/run)" expand="false">
            <cfdump var="#argMap#" label="argMap (UserFunc/run)" expand="false">
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