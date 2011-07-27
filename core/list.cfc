<cfcomponent extends="cfnDataType" implement="IRunnable,ISeq">
    
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
    
    <!--- define the closing char for this data type --->
    <cfset variables.closingChar = ")">

	<cffunction name="init">
		<cfargument name="inputData" type="any" hint="either a string (which will get parsed) or a List object">
        <cfargument name="scope" type="any">
		
        <cfset variables.scope = arguments.scope>

        <cfif url.explain>
            <strong>List</strong>.init()<br>
            <cfdump var="#inputData#" label="inputData (list/init)"><br>
        </cfif>

		<cfif isSimpleValue(arguments.inputData)>
            <cfset hashId = Hash(arguments.inputData)>
		<cfelse>
			<cftry>
				<cfif arguments.inputData.getType() IS "List">
					<cfdump var="#arguments.inputData._getData()#" label="arguments inputData data (list/init)">
					<cfreturn setData(arguments.inputData._getData())>
				<cfelse>
					Not a list...<cfabort>
				</cfif>
				<cfcatch><cfdump var="#inputData#" label="inputData (list/init) - error"><cfrethrow></cfcatch>
			</cftry>
		</cfif>
        
        <cfset var contentLength = Len(inputData)>
        <!--- if the function is already parsed (and saved) then use it --->
        <cfif StructKeyExists(scope, request.currentNS)>
            <cfif StructKeyExists(scope[request.currentNS], hashId)>
                <cfreturn scope[request.currentNS][hashId]>
            </cfif>
        <cfelse>
            <cfset scope[request.currentNS] = StructNew()>
        </cfif>
        
        <!--- send the incoming string through the incremental parser to create the object list --->
        <cfset inputData &= " ">
        <cfset contentLength ++>
        <cfset request.parserCount = 1>
        <cfloop from="1" to="#contentLength#" index="i">
            <cfset parseInc(mid(inputData, i, 1))>
        </cfloop>
        
		<!---
        <cfset contents = Replace(contents, ",", " ", "ALL")>
        
        <!--- TODO: Improve this step, it's currently pretty crude, as this will affect spaces in string literals too --->
        <cfset contents = REReplace(contents, "[ ]+", " ", "ALL")>
        
        <cfset variables.data = contents>
        <cfset variables.datanew = variables.parseSymbols[1][1]>
		--->
		
        <cfset scope[request.currentNS][hashId] = this>
        
        <cfset this.data = inputData>
        
        <cfreturn this>
	</cffunction>
	
    <!--- when you run a list, if the first item is a function, then we call that function with the reamining
    arguments. Otherwise, we return it as a list. --->
	<cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
		<cfset var firstToken = "">
        <cfset var fn = "">
        
        <cfif url.explain>
            <strong>List</strong>.run()<br>
            <cfdump var="#bindMap#" label="bindMap (List/run)" expand="false">
        </cfif>

        <cfif first().getType() IS "Token">
            <cfset fnName = first().data>
        <cfelse>
            <cfthrow message="the first element of a runnable list, must be a token. Ensure your first characters, within $("""") can be tokenised (ie not a structure or string)">
        </cfif>
        
        <!--- attempt to instantiate an object of type first param --->
        <cfif fnName IS NOT "." AND fnName IS NOT "core">
        </cfif>
        
        <!--- if we obtained a function or object, then we init() it, and return the new function object --->
        <cfif isObject(fn)>
            <cfif url.debug><cfoutput><p>--- LIST: #fnName# is an object, calling init <strong>#rest().toString()#</strong> ---</p></cfoutput></cfif>
            
        <!--- if the function is a UserFunc object, then call it here --->
        <cfelseif StructKeyExists(variables, "scope") AND StructKeyExists(variables.scope[request.currentNS], fnName)><!---  AND isObject(variables.scope[request.currentNS][fnName])> --->
            <cfif url.debug><cfoutput><p>--- LIST: creating custom function as UserFunc Object <strong>#fnName#</strong> ---</p></cfoutput></cfif>
            <cfset fnold = variables.scope[request.currentNS][fnName]>
            <cfset fn = Duplicate(variables.scope[request.currentNS][fnName])>
        
        <!--- if we are calling native CF functions --->
        <cfelseif isSimpleValue(fnName) AND fnName IS ".">
            <cfif url.debug><cfoutput><p>--- LIST: calling native <strong>CF</strong> function ---</p></cfoutput></cfif>
            <cfset fn = CreateObject("component", "CF")>
            
        <!--- if we are calling native CF functions --->
        <cfelseif isSimpleValue(fnName) AND fnName IS "core">
            <cfif url.debug><cfoutput><p>--- LIST: calling <strong>CORE</strong> function ---</p></cfoutput></cfif>
            <cfset fn = CreateObject("component", "fcfcore")>
            
        <cfelse>
            <cftry>
                <cftry>
                    <cfset fn = createObject("component", fnName)>
                    <cfif url.debug>Attempting to create an instance of <cfoutput>#fnName#</cfoutput><br></cfif>
                    <cfcatch>
                        <cfif url.debug><cfoutput>--- LIST: #fnName# is not a CFC/function object<br></cfoutput></cfif>
                        <cfif Left(cfcatch.message, 39) IS NOT "Could not find the ColdFusion component"
                                AND Left(cfcatch.message, 40) IS NOT "invalid component definition, can't find">
                            <cfdump var="#cfcatch.message#"><cfrethrow></cfif>
                    </cfcatch>
                </cftry>
                <cfcatch>
                    <cfdump var="#variables.scope#" label="variables.scope (list/run)" expand="false">
                    <cfdump var="#fn#" label="LIST: fn">
                    <cfthrow message="function #fnName# cannot be found">
                </cfcatch>
            </cftry>
            
        </cfif>
        
        <cfset resp = fn.init(rest(), variables.scope).run(arguments.bindMap)>
        
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
    
    <cffunction name="getType">
        <cfreturn "List">
    </cffunction>
    <cffunction name="toString">
        <cfset var internals = _getData()>
        <cfset var elems = ArrayLen(internals)>
        <cfset var i = 1>
        <cfset var resp = "">
        <cfloop from="1" to="#elems#" index="i">
            <cfset resp = ListAppend(resp, internals[i].toString(), " ")>
        </cfloop>
        <cfset resp = "(#resp#)">
        <cfreturn resp>
    </cffunction>
    
    <cffunction name="isEmpty" returntype="boolean">
        <cfif ArrayLen(variables.dataCore) EQ 0>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>
    
</cfcomponent>