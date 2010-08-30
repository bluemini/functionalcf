<cfcomponent>

	<cfset variables.data = "">

	<cffunction name="init">
		<cfargument name="contents">
        
        <cfset contents = replace(contents, ",", " ", "ALL")>
        <cfset contents = REReplace(contents, "[ ]+", " ", "ALL")>
        <cfset variables.data = contents>
		
		<!--- check that the incoming data is a struct --->
        <cfreturn this>
	</cffunction>
	
	<cffunction name="run">
		<cfset var fnName = ListGetAt(variables.data, 1, " ")>
        <cfset var fn = {}>
        
        <!--- attempt to instantiate an object of type first param --->
        <cftry>
            <cfset fn = createObject("component", fnName)>
            <cfcatch></cfcatch>
        </cftry>
        
        <cfif isObject(fn)>
            <cfif url.debug><cfoutput>--- called by Object fn ---<br></cfoutput></cfif>
            <cfset resp = fn.init(rest()).run()>
        <cfelseif isCustomFunction(fn)>
            <cfif url.debug><cfoutput>--- called by Custom Function fn ---<br></cfoutput></cfif>
            <cfset resp = fn(argumentCollection=newArgs)>
        <cfelseif isCustomFunction(fn)>
            <cfif url.debug><cfoutput>--- called by String var ---</cfoutput></cfif>
            <cfset tempFunc = variables[fn]>
            <cfset resp = tempFunc(newArgs)>
        <cfelse>
            <cfreturn print()>
        </cfif>
        
		<cfif structKeyExists(arguments, "arg1")>
			<cfset hashcode = hash(arguments["arg1"].tostring())>
		</cfif>
		<!--- try and locate the key and return the value --->
		<cfif structKeyExists(variables.data, hashcode)>
			<cfreturn variables.data[hashcode].data>
		<cfelse>
			<cfreturn "nil">
		</cfif>
	</cffunction>
	
    <cffunction name="print">
        <cfreturn "(" & variables.data & ")">
    </cffunction>
    
    <cffunction name="rest">
        <cfreturn createObject("component", "list").init(listDeleteAt(variables.data, 1, " "))>
    </cffunction>
    
	<cffunction name="_getData"><cfreturn variables.data></cffunction>
	
	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfargument name="methodName" required="true">
		<cfset var searchForKey = structFind(variables.data, arguments.methodName)>
		<cfdump var="#searchForKey#"><cfabort>
	</cffunction>

</cfcomponent>