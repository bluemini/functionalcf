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
    <cfset variables.dataFinalized = false>
    <cfset variables.dataBuild = "">
    <cfset variables.dataCore = ArrayNew(1)>

	<cffunction name="init">
		<cfargument name="contents" type="any" hint="either a string (which will get parsed) or a List object">
		
		<cfif isSimpleValue(arguments.contents)>
		<cfelse>
			<cftry>
				<cfif arguments.contents.getType() IS "List">
					<cfreturn setData(contents._getData())>
				<cfelse>
					Not a list...<cfabort>
				</cfif>
				<cfcatch><cfdump var="#contents#" label="contents (list/init) - error"><cfrethrow></cfcatch>
			</cftry>
		</cfif>
        
        <cfset var contentLength = Len(contents)>
        
        <cfset parse(contents)>
        
        <!--- send the incoming string through the incremental parser to create the object list --->
        <cfset contents &= " ">
        <cfset contentLength ++>
        <cfloop from="1" to="#contentLength#" index="i">
            <cfset parseInc(mid(contents, i, 1))>
        </cfloop>
        
		<!---
        <cfset contents = Replace(contents, ",", " ", "ALL")>
        
        <!--- TODO: Improve this step, it's currently pretty crude, as this will affect spaces in string literals too --->
        <cfset contents = REReplace(contents, "[ ]+", " ", "ALL")>
        
        <cfset variables.data = contents>
        <cfset variables.datanew = variables.parseSymbols[1][1]>
		--->
		
        <cfset this.data = contents>
        
        <cfreturn this>
	</cffunction>
	
    <!--- when you run a list, if the first item is a function, then we call that function with the reamining
    arguments. Otherwise, we return it as a list. --->
	<cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        <cfargument name="context" required="false" default="#this#">
        
		<cfset var firstToken = variables.dataCore[1]>
        <cfset var fn = "">
        
        <cfif firstToken.getType() IS "Token">
            <cfset fnName = firstToken.data>
        <cfelse>
            <cfthrow message="the first element of a runnable list, must be a token">
        </cfif>
        
        <!--- attempt to instantiate an object of type first param --->
        <cfif fnName IS NOT ".">
            <cftry>
                <cfif url.debug>Creating instance of <cfoutput>#fnName#</cfoutput><br></cfif>
                <cfset fn = createObject("component", fnName)>
                <cfcatch>
                    <cfif url.debug> - failed (#fnName# is not a function object)<br></cfif>
                    <cfif Left(cfcatch.message, 39) IS NOT "Could not find the ColdFusion component"
						AND Left(cfcatch.message, 40) IS NOT "invalid component definition, can't find">
							<cfdump var="#cfcatch.message#"><cfrethrow></cfif>
                </cfcatch>
            </cftry>
        </cfif>
        
        <!--- if we obtained a function or object, then we init() it, and return the new function object --->
        <cfif isObject(fn)>
            <cfif url.debug><cfoutput>--- LIST: #fnName# is an object, calling init("#rest().toString()#") ---<br></cfoutput></cfif>
            <cfset resp = fn.init(rest()).run(arguments.bindMap)>
            
        <cfelseif StructKeyExists(context, fnName) AND isObject(context[fnName])>
            <cfif url.debug><cfoutput>--- LIST: creating custom function as UserFunc Object #fnName# ---<br></cfoutput></cfif>
            <cfset resp = context[fnName].init(rest(), context).run(arguments.bindMap)>
        
        <!--- if we are calling native CF functions --->
        <cfelseif isSimpleValue(fnName) AND fnName IS ".">
            <cfif url.debug><cfoutput>--- LIST: calling native CF function ---<br></cfoutput></cfif>
            <cfset fn = CreateObject("component", "CF")>
            <cfset resp = fn.init(rest(), context).run(arguments.bindMap)>
            
        <cfelse>
            <cfdump var="#context#" label="context (list/run) - default action">
            <cfoutput>function name:#fnName# not a function<br>found function in context: #StructKeyExists(context, fnName)#</cfoutput>
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
        <cfif ArrayLen(variables.dataCore) GT 0>
            <cfset resp = variables.dataCore[1]>
        </cfif>
        <cfreturn resp>
    </cffunction>
    <cffunction name="rest">
        <cfset var resp = ArrayNew(1)>
        <cfset var rest = CreateObject("component", "List")>
        
        <cfif ArrayLen(variables.dataCore) GT 0>
            <cfset resp = Duplicate(variables.dataCore)>
            <cfset ArrayDeleteAt(resp, 1)>
        </cfif>
        
        <cfset rest.setData(resp)>
        <cfreturn rest>
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

	<cffunction name="_getData">
        <cfreturn variables.dataCore>
    </cffunction>
    <cffunction name="setData">
        <cfargument name="data" type="array">
        <cfset variables.dataCore = data>
        <cfreturn this>
    </cffunction>
    <cffunction name="length">
        <cfreturn ArrayLen(variables.dataCore)>
    </cffunction>
    
    <!--- takes a char at a time and fills its internal array --->
	<cffunction name="parseInc">
        <cfargument name="char">
        
        <cfset var finished = false>
        <cfset var result = false>
        
        <cfif variables.dataFinalized><cfthrow message="list is immutable and cannot be modified"></cfif>
        
        <cfif StructKeyExists(variables, "dataType")>
            <cfset finished = variables.dataType.parseInc(char)>
        <cfelseif char IS "(">
            <cfset variables.dataType = CreateObject("component", "List")>
        <cfelseif char IS "[">
            <cfset variables.dataType = CreateObject("component", "Map")>
        <cfelseif char IS "{">
            <cfset variables.dataType = CreateObject("component", "Set")>
        <cfelseif char IS "'">
            <cfset variables.dataType = CreateObject("component", "String")>
        <cfelseif NOT ListFind(" ,[,],(,),{,}", char)>
            <cfset variables.dataType = CreateObject("component", "Token")>
            <cfset finished = variables.dataType.parseInc(char)>
        </cfif>
        
        <!--- if the data type has finished, then we stash current dataType --->
        <cfif finished>
            <cfset ArrayAppend(variables.dataCore, variables.dataType)>
            <cfset StructDelete(variables, "dataType")>
        </cfif>
        
        <!--- when a list self closes, it doesn't want an enclosing list to reuse the closing ) char,
            so it returns 2, asking the enclosing list to ignore the current value --->
        <cfif char IS ")" AND finished NEQ 2>
            <cfset result = 2>
        </cfif>

        <cfreturn result>
    </cffunction>
    
    <cffunction name="getType">
        <cfreturn "List">
    </cffunction>
    <cffunction name="toString">
        <cfreturn "to implement...">
    </cffunction>
    
	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfargument name="methodName" required="true">
		<cfset var searchForKey = structFind(variables.data, arguments.methodName)>
		<cfdump var="#searchForKey#"><cfabort>
	</cffunction>



</cfcomponent>