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
        <cfset var condArgs = false>
        
        <cfif url.debug OR url.explain>
            <strong>UserFunc</strong>.run()<br>
            <cfoutput>FunctionDetail.ARGS: #variables.functionDetail.args.toString()# /#variables.functionDetail.args.getType()#<br></cfoutput>
            <cfoutput>FunctionDetail.BODY: #variables.functionDetail.body.toString()# /#variables.functionDetail.body.getType()#<br></cfoutput>
        </cfif>
        
        <!--- blend the bindMap data, which contains the real values, with handlers specified in args --->
        <cfloop array="#variables.functionDetail.args._getData()#" index="handle">
            
            <!--- if the handle is '&' then we need to skip to the next handle and setup a seq to record the remaining input values --->
            <cfif handle.equals("&")>
                <cfset condArgs = true>
                <cfcontinue/>
            </cfif>
            
            <!--- fetch the next data value from the inputData list --->
            <cfset dataFirst = data.first()>
            
            <cfif url.explain>
                <cfoutput>handle:#handle.toString()#<br>
                data.first(): #dataFirst.toString()#<br>
                condArgs: #condArgs#<br></cfoutput>
            </cfif>
            
            <!--- if the refernced var is in global scope (variables) assign it --->
            <cfset boundValue = evalboundvalue(data, dataFirst, bindMap)>
            
            <cfif condArgs>
                <cfset condArgsArray = ArrayNew(1)>
                <cfloop condition="boundValue IS NOT ''">
                    <cfset ArrayAppend(condArgsArray, boundValue)>
                    <cfset data = data.rest()>
                    <cfset dataFirst = data.first()>
                    <cfset boundValue = evalBoundValue(data, dataFirst, bindMap)>
                </cfloop>
                <cfset argMap[handle.toString()] = CreateObject("List").setData(condArgsArray)>
            <cfelse>
                <cfset argMap[handle.toString()] = boundValue>
            </cfif>
            
            <cfif url.explain>
                <cfoutput>Bound value #boundValue# to #handle.toString()#<br></cfoutput>
            </cfif>
            
            <!--- take the current data off the top of the list and return the rest --->
            <cfset data = data.rest()>
            
        </cfloop>
        
        <!--- if the rest is NOT empty, then we haven't passed in the correct number of args --->
        <cfif NOT data.isEmpty()>
            <cfdump var="#data#">
            <cfoutput>#data.toString()#</cfoutput>
            <cfthrow message="arity error..">
        </cfif>

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

    <cffunction name="evalBoundValue" access="private">
        <cfargument name="data">
        <cfargument name="dataFirst">
        <cfargument name="bindMap">
        
        <cfset var resp = "">
        <cfset var boundValue = "">
        <cfset var n = "">
        
        <!--- if the dataFirst symbol is not a FCF object, throw an error --->
        <cftry>
            <cfset n = dataFirst.getType()>
            <cfcatch>
                <!--- 
                Not enough terms passed in to satisfy the arguments defined.<br>
                <cfoutput>FunctionDetail.ARGS: #variables.functionDetail.args.toString()# /#variables.functionDetail.args.getType()#<br></cfoutput>
                <cfoutput>FunctionDetail.BODY: #variables.functionDetail.body.toString()# /#variables.functionDetail.body.getType()#<br></cfoutput>
                <cfdump var="#data.toString()#">
                <cfdump var="#dataFirst#">
                --->
                <cfreturn "">
            </cfcatch>
        </cftry>
        
        <cfif dataFirst.getType() IS "list">
            <cfif url.explain>
                <cfoutput>Running #dataFirst.toString()#<br>
                <div style="border:1px solid green; padding: 5px"></cfoutput>
            </cfif>
            <!--- the use of an intermediary variable seemed to be necessary for Railo to store the correct value --->
            <cfset resp = dataFirst.run(bindMap, variables.scope)>
            <cfif url.explain>
                <cfoutput></div>returned #resp.toString()#</cfoutput><br>
            </cfif>
            <cfset boundValue = resp>
        <cfelseif StructKeyExists(variables.scope, dataFirst.toString())>
            <cfset boundValue = variables.scope[data.first().toString()]>
        <cfelseif StructKeyExists(bindMap, dataFirst.toString())>
            <cfset boundValue = bindMap[data.first().toString()]>
        <cfelseif data.first().getType() IS "String">
            <cfset boundValue = dataFirst.toString()>
        <cfelse>
            DANG! trying to resolve <cfoutput>#dataFirst.toString()# without success</cfoutput>
            <!--- <cfdump var="#bindMap#">
            <cfdump var="#variables.scope#">
            <cfthrow> --->
            <cfset boundValue = dataFirst.toString()>
        </cfif>
        
        <cfreturn boundValue>
    </cffunction>
    
    <cffunction name="getContents">
        <cfreturn variables.inputData>
    </cffunction>

</cfcomponent>