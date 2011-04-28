<cfcomponent extends="func" implements="IRunnable">

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("Lt", arguments.contents, this)>
        
        <!--- ensure that there are at least two entries --->
        <cfif contents.length LT 2>
            <cfthrow message="LT requires at least one argument (master [first compare [second compare]])">
        </cfif>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        <!--- get the response from running the first argument --->
        <cfset var arg = variables.contents.first().data>
        <cfset var rest = variables.contents.rest()>
        <cfset var mainArg = "">
        <cfset var compArg = "">
        <cfset var result = true>
        
        <cfif isNumeric(arg)>
            <cfset mainArg = CreateObject("component", "Number").init(arg)>
        <cfelseif isBoolean(arg)>
            <cfset mainArg = CreateObject("component", "TBoolean").init(arg)>
        <cfelseif isSimpleValue(arg)>
            <cfset mainArg = CreateObject("component", "String").init(arg)>
        <cfelse>
            <cfset mainArg = arg>
        </cfif>
        
        <!--- get each element, compare --->
        <cfloop condition="result AND rest.length() GT 0">
            <cfset compArg = rest.first().data>
            <cfset result = result AND (arg LT compArg)>
            <cfset arg = compArg>
            <cfset rest = rest.rest()>
        </cfloop>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>