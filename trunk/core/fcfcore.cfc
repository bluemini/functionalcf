<cfcomponent extends="func" displayName="FunctionalCF Core">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="inputData" type="any">
        <cfargument name="scope" type="any">
        
        <cfset super.init("fcfcore", arguments.inputData, arguments.scope)>
        
        <cfif url.explain>
            "Contents" passed to fcfcore: <cfoutput>#variables.inputData.toString()#</cfoutput>
        </cfif>
        
        <!--- args is a List where the first arg should be the CF function name --->
        <cfset variables.f = variables.inputData.first().data>
        
        <cfif StructKeyExists(this, f)>
            <cfset variables.t = this[f]>
        <cfelse>
            <cfthrow message="no native function #f# that can be called.">
        </cfif>
		
		<cfreturn this>
    </cffunction>

    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        <!--- on CF, I can save the local function (from within init) to variables.f
        and then call it here, however, Railo complains that the 'private' function doesn't
        exist (not sure why it thinks it should be private. However, the following syntax
        works in Railo, but CF complains that it's invalid CFML.
		<cfreturn this[variables.f](arguments.bindMap, variables.contents.rest())>
         --->
        <cfset var f = this[variables.f]>
		
        <cfif url.explain OR url.debug>
			<cfoutput>Running fcfcore, function: '#variables.f#', arguments: #variables.inputData.rest().toString()#</cfoutput>
			<cfdump var="#variables.inputData.rest()#">
		</cfif>
        
        <cfreturn f(arguments.bindMap, variables.inputData.rest())>
    </cffunction>
	
	<cffunction name="first">
		<cfargument name="bindMap">
		<cfargument name="args">

        <!--- fetch the first item from the args and resolve any local bindings --->
		<cfset var arg = args.first()>
        
        <cfif url.explain or url.debug>
            <p>Arguments passed to fcfcore.first <cfoutput>#args.toString()#</cfoutput></p>
            <p>, the first item is the argument collection. <cfoutput>#arg.toString()#</cfoutput></p>
        </cfif>
        
        <!--- if the arg is a token we need to check if it's numeric or can be resolved to a local binding --->
		<cfif arg.getType() IS "token">
            <cfset arg = arg.data>
            
            <cfif url.explain>
                <cfoutput><p>arg is a token (#arg#)</cfoutput>
            </cfif>
            <cfif isNumeric(arg)>
                <cfif url.explain>
                    <cfoutput>and is numeric, so we leave it alone</p></cfoutput>
                </cfif>
    		<cfelseif StructKeyExists(bindMap, arg)>
                <cfset arg = bindMap[arg]>
                <cfif url.explain>
                    <cfoutput>, can be bound and resolves to: #arg.toString()#</p></cfoutput>
                    <cfdump var="#bindMap#" label="bindMap (fcfcore/run)" expand="false">
                </cfif>
            <cfelseif StructKeyExists(variables.scope, arg)>
                <cfset arg = variables.scope[arg]>
                <cfif url.explain>
                    <cfoutput>and can be bound</p><p>#arg.toString()#</p></cfoutput>
                    <cfdump var="#arg#">
                </cfif>
            <cfelse>
                <cfif url.explain>
                    <cfoutput>,is not numeric and cannot be bound, so what do we do...throw an error!</p></cfoutput>
                </cfif>
                <cfthrow message="token cannot be converted into a value '#arg#'">
            </cfif>
        </cfif>
        
        <!--- if the binding resolved to var/symbol, we must resolve that too --->
        <cftry><cfset arg.getType()><cfcatch><cfdump var="#arg#"><cfabort></cfcatch></cftry>
        <cfif arg.getType() IS "token">
            <cfif StructKeyExists(variables.scope, arg.data)>
                <cfset arg = variables.scope[arg.data]>
                <cfif url.explain>
                    <cfoutput><p>The token resolved to another token, so we need to look at non-local bindings to resolve</p></cfoutput>
                    <cfdump var="#arg#">
                </cfif>
            <cfelse>
                <cfthrow message="cannot resolve token '#arg.data#' into a value">
            </cfif>
        </cfif>

        <cfif arg.getType() IS "list">
            <cfif url.explain>
                <cfoutput>going to run #arg.toString()#, passing bindMap and scope<br></cfoutput>
            </cfif>
            <cfset arg = arg.run(arguments.bindMap, variables.scope)>
        <cfelseif StructKeyExists(arg, "data") AND StructKeyExists(variables.scope, arg.data)>
            <cfset arg = variables.scope[arg.data]>
		</cfif>
        
		<cfreturn arg.first()>
	</cffunction>
    
    <cffunction name="out">
        <cfargument name="bindMap">
        <cfargument name="args">
        
        <cfset resp = "">
        
        <cfif url.explain>
            <cfdump var="#bindMap#" label="bindMap (FCFCore/out)">
            <cfdump var="#args.toString()#" label="args (FCFCore/out)">
        </cfif>

        <!--- fetch the first item from the args and resolve any local bindings --->
        <cfset var arg = args.first().toString()>
        
        <cfloop condition="arg IS NOT ''">
            <cfif StructKeyExists(bindMap, arg)>
                <cftry>
                    <cfset boundValue = bindMap[arg]>
                    <cfif isSimpleValue(boundValue)>
                        <cfset resp = ListAppend(resp, boundValue, " ")>
                    <cfelseif boundValue.getType() IS "List">
                        <cfset arg = boundValue.first()>
                        <cfloop condition="arg IS NOT ''">
                            <cfif isSimpleValue(arg)>
                                <cfset resp = ListAppend(resp, arg, " ")>
                            <cfelseif arg.getType() IS "Token">
                                <cfset resp = ListAppend(resp, arg.toString(), " ")>
                            <cfelse>
                                <cfthrow message="rest isn't a token">
                            </cfif>
                            <cfset boundValue = boundValue.rest()>
                            <cfset arg = boundValue.first()>
                        </cfloop>
                    </cfif>
                    <cfcatch><cfdump var="#bindMap#"></cfcatch>
                </cftry>
            </cfif>
            <cfset args = args.rest()>
            <cfset arg = args.first().toString()>
        </cfloop>
        
        <cfreturn resp>
    </cffunction>

    <cffunction name="sub">
        <cfargument name="bindMap">
        <cfargument name="args">
        
        <cfset resp = "">
        
        <cfif url.explain>
            <cfdump var="#bindMap#" label="bindMap (FCFCore/sub)">
            <cfdump var="#args.toString()#" label="args (FCFCore/sub)">
        </cfif>

        <!--- fetch the first item from the args and resolve any local bindings --->
        <cfset var arg = args.first().toString()>
        
        <cfloop condition="arg IS NOT ''">
            <cfif StructKeyExists(bindMap, arg)>
                <cftry>
                    <cfset boundValue = bindMap[arg]>
                    <cfif isSimpleValue(boundValue) AND isNumeric(boundValue)>
                        <cfif resp IS "">
                            <cfset resp = boundValue>
                        <cfelse>
                            <cfset resp = resp - boundValue>
                        </cfif>
                    <cfelse>
                        <cfthrow message="rest isn't a token">
                    </cfif>
                    <cfcatch></cfcatch>
                </cftry>
            </cfif>
            <cfset args = args.rest()>
            <cfset arg = args.first().toString()>
        </cfloop>
        
        <cfreturn resp>
    </cffunction>

    <cffunction name="sum">
        <cfargument name="bindMap">
        <cfargument name="args">
        
        <cfset resp = 0>
        
        <cfif url.explain>
            <cfdump var="#bindMap#" label="bindMap (FCFCore/sum)">
            <cfdump var="#args.toString()#" label="args (FCFCore/sum)">
        </cfif>

        <!--- fetch the first item from the args and resolve any local bindings --->
        <cfset var arg = args.first().toString()>
        
        <cfloop condition="arg IS NOT ''">
            <cfif StructKeyExists(bindMap, arg)>
                <cftry>
                    <cfset boundValue = bindMap[arg]>
                    <cfif isSimpleValue(boundValue) AND isNumeric(boundValue)>
                        <cfset resp += boundValue>
                    <cfelse>
                        <cfthrow message="rest isn't a token">
                    </cfif>
                    <cfcatch></cfcatch>
                </cftry>
            </cfif>
            <cfset args = args.rest()>
            <cfset arg = args.first().toString()>
        </cfloop>
        
        <cfreturn resp>
    </cffunction>

</cfcomponent>