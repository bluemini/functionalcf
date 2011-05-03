<cfcomponent extends="func" displayName="FunctionalCF Core">

    <cffunction name="init" returntype="any" output="true" >
        <cfargument name="contents" type="any">
        <cfargument name="scope" type="any">
        
        <cfset super.init("fcfcore", arguments.contents, arguments.scope)>
        
        <!--- args is a List where the first arg should be the CF function name --->
        <cfset variables.f = variables.contents.first().data>
        
        <cfif StructKeyExists(this, f)>
            <cfset variables.t = this[f]>
        <cfelse>
            <cfthrow message="no native function #f# that can be called.">
        </cfif>
		
		<cfreturn this>
    </cffunction>

    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
		<cfreturn this[variables.f](arguments.bindMap, variables.contents.rest())>
    </cffunction>
	
	<cffunction name="first">
		<cfargument name="bindMap">
		<cfargument name="args">

		<cfset var arg = args.first().data>
		<cfif isNumeric(arg)>
		<cfelseif StructKeyExists(bindMap, arg)>
			<cfset arg = bindMap[arg]>
		</cfif>
		
		<cfdump var="#arg#"><cfabort>

		<cfreturn arg.first()>
	</cffunction>

</cfcomponent>