<cfcomponent implements="IIterable">
	
	<cfset variables.data = structNew()>
    <cfset variables.dataFinalized = false>
    <cfset variables.dataBuild = "">
    <cfset variables.dataCore = ArrayNew(1)>
    
	<!--- creates a map object, it expects a CF struct --->
	<cffunction name="init">
		<cfargument name="datastruct">
		
		<!--- check that the incoming data is a struct --->
		<cfif NOT isArray(arguments.datastruct)>
			<cfthrow message="Unable to define a map given the data provided">
		<cfelseif arrayLen(arguments.datastruct) mod 2 NEQ 0>
			<cfthrow message="Uneven number of attributes in the map initialisation string">
		<cfelse>
			<cfloop from="1" to="#arrayLen(arguments.datastruct)#" index="i" step="2">
				<cfset hashcode = hash(arguments.datastruct[i].tostring())>
                <cfset variables.data[hashcode] = structNew()>
				<cfset variables.data[hashcode].key = arguments.datastruct[i]>
				<cfset variables.data[hashcode].data = arguments.datastruct[i+1]>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="run">
		<cfset var hashcode = "">
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
	
	<cffunction name="getData"><cfreturn variables.data></cffunction>
	
    <!--- takes a char at a time and fills its internal array --->
    <cffunction name="parseInc">
        <cfargument name="char">
        
        <cfset var finished = false>
        <cfset var result = false>
        
        <cfif variables.dataFinalized><cfthrow message="list is immutable and cannot be modified"></cfif>
        
        <cfif char IS "(">
            CREATE LIST<br>
            <cfset variables.dataType = CreateObject("component", "List")>
        <cfelseif char IS "[">
            CREATE MAP<br>
            <cfset variables.dataType = CreateObject("component", "Map")>
        <cfelseif char IS "{">
            CREATE SET<br>
            <cfset variables.dataType = CreateObject("component", "Set")>
        <cfelseif char IS "'">
            CREATE STRING<br>
            <cfset variables.dataType = CreateObject("component", "String")>
        <cfelseif char IS NOT "]">
            <cfif NOT StructKeyExists(variables, "dataType")>
                <cfset variables.dataType = CreateObject("component", "Token")>
            </cfif>
            <cfset finished = variables.dataType.parseInc(char)>
        <cfelseif char IS "]">
            <cfset result = true>
            <cfset finished = true> <!--- force the flushing of the last object to the dataCore --->
        </cfif>
        
        <!--- if the data type has finished, then we stash current dataType --->
        <cfif finished>
            <cfset ArrayAppend(variables.dataCore, variables.dataType)>
            <cfset StructDelete(variables, "dataType")>
        </cfif>
        
        <cfreturn result>
    </cffunction>
    
	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfargument name="methodName" required="true">
		<cfset var searchForKey = structFind(variables.data, arguments.methodName)>
		<cfdump var="#searchForKey#"><cfabort>
	</cffunction>

    <cffunction name="getType">
        <cfreturn "Map">
    </cffunction>
    
    <cffunction name="getNext" returntype="any">
	</cffunction>

</cfcomponent>