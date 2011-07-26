<cfcomponent extends="cfnDataType"  implements="IIterable,IRunnable">
	
	<cfset variables.data = "">
    <cfset variables.dataFinalized = false>
    <cfset variables.dataBuild = "">
    <cfset variables.dataCore = ArrayNew(1)>
    
    <!--- define the closing char for this data type --->
    <cfset variables.closingChar = "]">
        
	<!--- creates a map object, it expects a CF struct --->
	<cffunction name="init" returntype="any" output="true">
        <cfargument name="inputData" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("defn", arguments.inputData, arguments.scope)>
        
        <cfreturn this>
	</cffunction>
	
	<cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
        <cfif NOT isStruct(variables.data)>
            <cfset variables.data = StructNew()>
            <cfset mapLen = ArrayLen(variables.dataCore)>
            <cfif mapLen MOD 2 GT 0><cfthrow message="Maps must have a factor of 2 keys"></cfif>
            <cfloop from="1" to="#mapLen#" index="i" step="2">
                <!---
                <cfset variables.data[variables.dataCore[i].data] = variables.dataCore[i+1].data>
                --->
            </cfloop>
        </cfif>
        
		<!--- try and locate the key and return the value --->
		<cfif StructKeyExists(variables.data, variables.inputData.first().data)>
			<cfreturn variables.data[variables.inputData.first().data]>
		<cfelse>
			<cfreturn "nil">
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
    
    <cffunction name="first">
        <cfreturn variables.dataCore[1]>
    </cffunction>
    <cffunction name="rest">
        <cfset var resp = Duplicate(variables.dataCore)>
        <cfset ArrayDeleteAt(resp, 1)>
        <cfreturn CreateObject("component", "Map").setData(resp)>
    </cffunction>
	
    <!--- takes a char at a time and fills its internal array --->
    <cffunction name="xxparseInc" output="true">
        <cfargument name="char">
        
        <cfset var finished = "">
        <cfset var result = 0>
        
        Processing <cfoutput>'#char#'</cfoutput> in Map<br>
        
        <cfif variables.dataFinalized><cfthrow message="list is immutable and cannot be modified"></cfif>
        
        <cfif StructKeyExists(variables, "dataType")>
            Adding <cfoutput>'#char#' to #variables.dataType.getType()#</cfoutput><br>
            <cfset finished = variables.dataType.parseInc(char)>
        <cfelseif char IS "(">
            New List<br>
            <cfset variables.dataType = CreateObject("component", "List")>
        <cfelseif char IS "[">
            Map/New Vector<br>
            <cfset variables.dataType = CreateObject("component", "Map")>
        <cfelseif char IS "{">
            New Set<br>
            <cfset variables.dataType = CreateObject("component", "Set")>
        <cfelseif char IS "'">
            New String<br>
            <cfset variables.dataType = CreateObject("component", "String")>
        <cfelseif NOT ListFind(" ,[,],(,),{,}", char)>
            Map/New Token<br>
            <cfset variables.dataType = CreateObject("component", "Token")>
            <cfset finished = variables.dataType.parseInc(char)>
        </cfif>
        
        <!--- if the data type has finished, then we stash current dataType --->
        <cfif finished GT 0>
            Map/Closing <cfoutput>#variables.dataType.getType()#/finished: #finished#</cfoutput><br>
            <cfset ArrayAppend(variables.dataCore, variables.dataType)>
            <cfset StructDelete(variables, "dataType")>
        </cfif>
        
        <!--- when a map self closes, it doesn't want an enclosing list to reuse the closing ) char,
            so it returns 2, asking the enclosing list to ignore the current value --->
        <cfif char IS "]" AND finished EQ 2>
            <cfset result = 1>
        <cfelseif char IS "]" AND finished EQ 1>
            <cfset result = 0>
        <cfelseif char IS "]" AND finished IS "">
            <cfset result = 1>
        </cfif>

        Map/returning <cfoutput>#result#</cfoutput><br>
        <cfreturn result>
    </cffunction>
    
    <cffunction name="getType">
        <cfreturn "Vector">
    </cffunction>
    <cffunction name="toString">
        <cfset var internals = _getData()>
        <cfset var elems = ArrayLen(internals)>
        <cfset var i = 1>
        <cfset var resp = "">
        <cfloop from="1" to="#elems#" index="i">
            <cfset resp = ListAppend(resp, internals[i].toString(), " ")>
        </cfloop>
        <cfset resp = "[#resp#]">
        <cfreturn resp>
    </cffunction>
    
    <cffunction name="getNext" returntype="any">
	</cffunction>

</cfcomponent>