<cfset codeString = "defn myfunc [num denom] (if (lt num denom) 'less than one' 'greater than or equal to one')">

<cfset List = CreateObject("component", "core.list")>

<cfloop from="1" to="#Len(codeString)#" index="i">
    <cfset char = mid(codeString, i, 1)>
    <cfoutput>#char#<br></cfoutput>
    <cfset List.parseInc(char)>
</cfloop>

<cfdump var="#List#">
<cfdump var="#List._getDataCore()#">