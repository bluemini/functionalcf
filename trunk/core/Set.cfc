<cfcomponent extends="func" implement="IRunnable,ISeq">
    
    <!---
        Represents a list of items in FCF
        
        Has basic implementation fucntionality
            First/Rest
            Print()
            It is used as the means to passing a description of a function to a functional object
    --->

	<cfset variables.data = "">
    <cfset variables.meta = StructNew()>
    
    <!--- define the closing char for this data type --->
    <cfset variables.closingChar = "}">
    
	<cffunction name="init">
		<cfargument name="contents" type="any">
        
        <cfset parse(contents)>
        
        <cfset contents = Replace(contents, ",", " ", "ALL")>
        
        <!--- TODO: Improve this step, it's currently pretty crude, as this will affect spaces in string literals too --->
        <cfset contents = REReplace(contents, "[ ]+", " ", "ALL")>
        
        <cfset variables.data = contents>
        <cfset variables.datanew = variables.parseSymbols[1][1]>
        <cfset this.data = contents>
        
        <cfreturn this>
	</cffunction>
	
    <!--- when you run a list, if the first item is a function, then we call that function with the reamining
    arguments. Otherwise, we return it as a list. --->
	<cffunction name="run">
        <cfargument name="context" required="false" default="#this#">
        
		<cfset var fnName = ListGetAt(variables.data, 1, " ")>
        <cfset var fn = "">
        
        <!--- attempt to instantiate an object of type first param --->
        <cfif fnName IS NOT ".">
            <cftry>
                <cfif url.debug>Creating instance of <cfoutput>#fnName#</cfoutput><br></cfif>
                <cfset fn = createObject("component", fnName)>
                <cfcatch>
                    <cfif url.debug> - failed (#fnName# is not a function object)<br></cfif>
                    <cfif Left(cfcatch.message, 39) IS NOT "Could not find the ColdFusion component"><cfdump var="#cfcatch.message#"><cfrethrow></cfif>
                </cfcatch>
            </cftry>
        </cfif>
        
        <!--- if we obtained a function or object, then we init() it, and return the new function object --->
        <cfif isObject(fn)>
            <cfif url.debug><cfoutput>--- LIST: #fnName# is an object, calling init("#rest().data#") ---<br></cfoutput></cfif>
            <cfset resp = fn.init(rest()).run()>
            
        <cfelseif StructKeyExists(context, fnName) AND isObject(context[fnName])>
            <cfif url.debug><cfoutput>--- LIST: creating custom function as UserFunc Object #fnName# ---<br></cfoutput></cfif>
            <cfset resp = context[fnName].init(rest(), context).run()>
        
        <!--- if we are calling native CF functions --->
        <cfelseif isSimpleValue(fnName) AND fnName IS ".">
            <cfif url.debug><cfoutput>--- LIST: calling native CF function ---</cfoutput></cfif>
            <cfset fn = CreateObject("component", "CF")>
            <cfset resp = fn.run(rest())>
            
        <cfelse>
            <cfdump var="#context#">
            <cfoutput>#fnName# #StructKeyExists(context, fnName)#</cfoutput>
            <cfset resp = print()>
            <cfabort>
            
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
        <cfset var resp = "">
        <!--- get the first element of the primary list --->
        <cfif Len(Trim(variables.data)) GT 0>
            <cfset resp = ListGetAt(variables.data, 1, " ")>
        </cfif>
        <cfreturn resp>
    </cffunction>
    <cffunction name="rest">
        <cfset var rest = listDeleteAt(variables.data, 1, " ")>
        <cfif Trim(rest) IS "">
            <cfreturn CreateObject("component", "List").init("")>
        <cfelse>
            <cfreturn createObject("component", "list").init(rest)>
        </cfif>
    </cffunction>
    
    <cffunction name="firstx">
        <cfset var resp = "">
        <!--- get the first element of the primary list --->
        <cfif Len(Trim(variables.datanew)) GT 0>
            <cfset resp = ListGetAt(variables.datanew, 1, " ")>
        </cfif>
        <!--- if there is a var, then resolve --->
        <cfreturn resp>
    </cffunction>
    <cffunction name="restx">
        <cfset var rest = listDeleteAt(variables.datanew, 1, " ")>
        <cfif Trim(rest) IS "">
            <cfreturn CreateObject("component", "List").init("")>
        <cfelse>
            <cfreturn createObject("component", "list").init(rest)>
        </cfif>
    </cffunction>    
	<cffunction name="_getData"><cfreturn variables.data></cffunction>
    
    
    <cffunction name="special">
        <cfargument name="data" type="array">
        <cfset variables.special = data>
        <cfreturn this>
    </cffunction>
    
    <cffunction name="getType">
        <cfreturn "Set">
    </cffunction>
    	
	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfargument name="methodName" required="true">
		<cfset var searchForKey = structFind(variables.data, arguments.methodName)>
		<cfdump var="#searchForKey#"><cfabort>
	</cffunction>



</cfcomponent>