<cfcomponent extends="func">
    
    <cfset variables.dataCore = ArrayNew(1)>
    <cfset variables.lastChar = "">

    <!--- takes a char at a time and fills its internal array --->
    <cffunction name="parseInc" output="true">
        <cfargument name="char">
        
        <cfset var finished = "">
        <cfset var result = 0>
        <cfset var thisType = getType()>
        
        <cfif variables.dataFinalized><cfthrow message="list is immutable and cannot be modified"></cfif>
        
        <cfif StructKeyExists(variables, "dataType")>
            #thisType#/Adding <cfoutput>'#char#' to #variables.dataType.getType()#</cfoutput><br>
            <cfset finished = variables.dataType.parseInc(char)>
        <cfelseif char IS "(">
            #thisType#/New Vector<br>
            <cfset variables.dataType = CreateObject("component", "List")>
            <cfif lastChar IS "'">
                <cfset variables.dataType.quoted(true)>
            </cfif>
        <cfelseif char IS "[">
            #thisType#/New Vector<br>
            <cfset variables.dataType = CreateObject("component", "Vector")>
        <cfelseif char IS "{">
            <cfif lastChar IS """">
                #thisType#/New Set<br>
                <cfset variables.dataType = CreateObject("component", "Set")>
            <cfelse>
                #thisType#/New Map<br>
                <cfset variables.dataType = CreateObject("component", "Map")>
            </cfif>
        <cfelseif char IS """">
            #thisType#/New String<br>
            <cfset variables.dataType = CreateObject("component", "String")>
        <cfelseif NOT ListFind(" ,[,],(,),{,}", char)>
            #thisType#/New Token<br>
            <cfset variables.dataType = CreateObject("component", "Token")>
            #thisType#/Adding <cfoutput>'#char#' to #variables.dataType.getType()#</cfoutput><br>
            <cfset finished = variables.dataType.parseInc(char)>
        </cfif>
        
        <!--- if the data type has finished, then we stash current dataType --->
        <cfif finished GT 0>
            #thisType#/Closing <cfoutput>#variables.dataType.getType()#/finished: #finished#</cfoutput><br>
            <cfset ArrayAppend(variables.dataCore, variables.dataType)>
            <cfset StructDelete(variables, "dataType")>
        </cfif>
        
        <!--- when a list self closes, it doesn't want an enclosing list to reuse the closing ) char,
            so it returns 2, asking the enclosing list to ignore the current value --->
        <cfif char IS variables.closingChar AND finished EQ 2>
            <cfset result = 1>
        <cfelseif char IS closingChar AND finished EQ 1>
            <cfset result = 0>
        <cfelseif char IS closingChar AND finished IS "">
            <cfset result = 1>
        </cfif>

        List/returning <cfoutput>#result#</cfoutput><br>
        <cfset lastChar = char>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>