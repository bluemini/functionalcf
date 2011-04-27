<cfcomponent implement="IRunnable">
    
    <!---
        Represents a list of items in FCF
        
        Has basic implementation fucntionality
            First/Rest
            Print()
            It is used as the means to passing a description of a function to a functional object
    --->

	<cfset variables.data = "">
    <cfset variables.meta = StructNew()>

	<cffunction name="init">
		<cfargument name="contents" type="any">
        
        <cfset contents = Replace(contents, ",", " ", "ALL")>
        
        <!--- TODO: Improve this step, it's currently pretty crude, as this will affect spaces in string literals too --->
        <cfset contents = REReplace(contents, "[ ]+", " ", "ALL")>
        <cfset variables.data = contents>
        <cfset this.data = contents>
        
        <cfreturn this>
	</cffunction>
	
    <!--- when you run a list, if the first item is a function, then we call that function with the reamining
    arguments. Otherwise, we return it as a list. --->
	<cffunction name="run">
        <cfargument name="context" required="false" default="#this#">
        
		<cfset var fnName = ListGetAt(variables.data, 1, " ")>
        <cfset var fn = {}>
        
        <!--- attempt to instantiate an object of type first param --->
        <cftry>
            <cfif url.debug>Creating instance of <cfoutput>#fnName#</cfoutput><br></cfif>
            <cfset fn = createObject("component", fnName)>
            <cfcatch>
                <cfif url.debug> - failed (#fnName# is not a function object)<br></cfif>
                <cfif Left(cfcatch.message, 39) IS NOT "Could not find the ColdFusion component"><cfdump var="#cfcatch.message#"><cfrethrow></cfif>
            </cfcatch>
        </cftry>
        
        <!--- if we obtained a function or object, then we init() it, and return the new function object --->
        <cfif isObject(fn)>
            <cfif url.debug><cfoutput>--- #fnName# is an object, calling init("#rest().data#") ---<br></cfoutput></cfif>
            <cfset resp = fn.init(rest())>
            
        <cfelseif StructKeyExists(context, fnName) AND isCustomFunction(context[fnName])>
            <cfif url.debug><cfoutput>--- called by Custom Function fn ---<br></cfoutput></cfif>
            <cfset resp = fn(argumentCollection=newArgs)>
            
        <cfelseif isCustomFunction(fn)>
            <cfif url.debug><cfoutput>--- called by String var ---</cfoutput></cfif>
            <cfset tempFunc = variables[fn]>
            <cfset resp = tempFunc(newArgs)>
            
        <cfelse>
            <cfdump var="#context#">
            <cfset resp = print()>
            
        </cfif>
        
		<!--- <cfif structKeyExists(arguments, "arg1")>
			<cfset hashcode = hash(arguments["arg1"].tostring())>
		</cfif>
		<!--- try and locate the key and return the value --->
		<cfif structKeyExists(variables.data, hashcode)>
			<cfreturn variables.data[hashcode].data>
		<cfelse>
			<cfreturn "nil">
		</cfif> --->
        
        <cfreturn resp>
	</cffunction>
	
    <!--- not sure if this function is required...leaving in for a while. --->
    <cffunction name="print">
        <cfreturn "(" & variables.data & ")">
    </cffunction>
    
    <cffunction name="first">
        <cfreturn ListGetAt(variables.data, 1, " ")>
    </cffunction>
    <cffunction name="rest">
        <cfset var rest = listDeleteAt(variables.data, 1, " ")>
        <cfif Trim(rest) IS "">
            <cfreturn CreateObject("component", "Nil")>
        <cfelse>
            <cfreturn createObject("component", "list").init(rest)>
        </cfif>
    </cffunction>
    
	<cffunction name="_getData"><cfreturn variables.data></cffunction>
	
	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfargument name="methodName" required="true">
		<cfset var searchForKey = structFind(variables.data, arguments.methodName)>
		<cfdump var="#searchForKey#"><cfabort>
	</cffunction>



</cfcomponent>