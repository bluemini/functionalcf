<cfcomponent extends="func" displayName="FunctionalCF Core">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="inputData" type="any">
        <cfargument name="scope" type="any">
        
        <cfset super.init("fcfcore", arguments.inputData, arguments.scope)>
        
        <cfif url.debug or url.explain>
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
		<cfif url.explain>
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
    
    <cffunction name="println">
        <cfargument name="bindMap">
        <cfargument name="args">
        
        <cfset resp = "">
        
        <cfdump var="#bindMap#">
        <cfdump var="#args.toString()#">

        <!--- fetch the first item from the args and resolve any local bindings --->
        <cfset var arg = args.first()>
        
        <cfif StructKeyExists(bindMap, args.first().toString())>
            <cfset resp = ListAppend(resp, bindMap[args.first().toString()], " ")>
        </cfif>
        
        <cfreturn resp>
    </cffunction>

</cfcomponent>