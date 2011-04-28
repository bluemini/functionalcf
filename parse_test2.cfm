<cfset codeString = "defn myfunc [num denom] (if (lt num denom) 'less than one' 'greater than or equal to one')">
<cfset codeLen = Len(codeString)>

<cfset inSpace = false>
<cfset inString = false>
<cfset inList = true>

<cfset variables.parseCurrentSymbol = 1>
<cfset variables.parseCurrentStackTop = 0>
<cfset symcount = 1>
<cfset symbol = "">

<cfset variables.parseSymbols[variables.parseCurrentSymbol] = ArrayNew(1)>
<cfset variables.parseSymbols[variables.parseCurrentSymbol][1] = "">
<cfset variables.parseSymbols[variables.parseCurrentSymbol][2] = "BASE">
<cfset variables.parseSymbols[variables.parseCurrentSymbol][3] = ArrayNew(1)>
        
<cfloop from="1" to="#codeLen#" index="count">
    <cfset char = mid(codeString, count, 1)>
    <cfoutput><br>#char#</cfoutput>
    
    <!--- if we encounter a separator, then store the accumulated string --->
    <cfif ListFind(" ,(,),[,],{,}", char) AND NOT inSpace AND NOT inString AND symbol IS NOT "">
        <cfset ArrayAppend(variables.parseSymbols[variables.parseCurrentSymbol][3], symbol)>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " " & symbol>
        <cfoutput>STORE ::#symbol#::<br></cfoutput>
        <cfset symbol = "">
        <cfset inSpace = true>
    </cfif>
    
    <cfif char IS NOT " "><cfset inSpace = false></cfif>
    
    <cfif char IS "[">
        <!--- place the current parsed string on --->
        <cfset variables.parseCurrentStackTop++>
        <cfset variables.parseStack[variables.parseCurrentStackTop] = StructNew()>
        <cfset variables.parseStack[variables.parseCurrentStackTop].char = ']'>
        <cfset variables.parseStack[variables.parseCurrentStackTop].count = variables.parseCurrentSymbol>
        <cfset symCount++>
        <cfset variables.parseCurrentSymbol = symCount>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol] = ArrayNew(1)>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] = "">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][2] = "ARRAY">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][3] = ArrayNew(1)>
        <cfset inList = false>
        <cfdump var="#variables.parseSymbols#">
        <cfdump var="#variables.parseStack#">
    <cfelseif char IS "(">
        <!--- place the current parsed string on --->
        <cfset variables.parseCurrentStackTop++>
        <cfset variables.parseStack[variables.parseCurrentStackTop] = StructNew()>
        <cfset variables.parseStack[variables.parseCurrentStackTop].char = ')'>
        <cfset variables.parseStack[variables.parseCurrentStackTop].count = variables.parseCurrentSymbol>
        <cfset symCount++>
        <cfset variables.parseCurrentSymbol = symCount>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol] = ArrayNew(1)>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] = "">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][2] = "LIST">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][3] = ArrayNew(1)>
        <cfset inList = true>
        <cfdump var="#variables.parseSymbols#">
        <cfdump var="#variables.parseStack#">
    <cfelseif char IS "'" AND NOT inString>
        <!--- place the current parsed string on --->
        <cfset variables.parseCurrentStackTop++>
        <cfset variables.parseStack[variables.parseCurrentStackTop] = StructNew()>
        <cfset variables.parseStack[variables.parseCurrentStackTop].char = "'">
        <cfset variables.parseStack[variables.parseCurrentStackTop].count = variables.parseCurrentSymbol>
        <cfset symCount++>
        <cfset variables.parseCurrentSymbol = symCount>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol] = ArrayNew(1)>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] = "">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][2] = "STRING">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][3] = ArrayNew(1)>
        <cfset inString = true>
        <cfset inList = false>
        <cfdump var="#variables.parseSymbols#">
        <cfdump var="#variables.parseStack#">
    <cfelseif char IS "]">
        <!--- save the list --->
        <cfset obj = CreateObject("component", "core.Set").special(variables.parseSymbols[variables.parseCurrentSymbol][3])>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " " & symbol>
        <cfset symbol = "">
        <!--- check the top of the stack --->
        <cfif variables.parseStack[variables.parseCurrentStackTop].char IS NOT char>
            <cfthrow message="unmatched [] in function definition...">
        </cfif>
        <cfset variables.symbolSymbol = variables.parseCurrentSymbol>
        <cfset variables.parseCurrentSymbol = variables.parseStack[variables.parseCurrentStackTop].count>
        <cfset variables.parseCurrentStackTop-->
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " :#symbolSymbol#">
        <cfset ArrayAppend(variables.parseSymbols[variables.parseCurrentSymbol][3], obj)>
    <cfelseif char IS ")">
        <!--- save the list --->
        <cfset obj = CreateObject("component", "core.List").special(variables.parseSymbols[variables.parseCurrentSymbol][3])>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " " & symbol>
        <cfset symbol = "">
        <!--- check the top of the stack --->
        <cfif variables.parseStack[variables.parseCurrentStackTop].char IS NOT char>
            <cfthrow message="unmatched () in function definition...">
        </cfif>
        <cfset variables.symbolSymbol = variables.parseCurrentSymbol>
        <cfset variables.parseCurrentSymbol = variables.parseStack[variables.parseCurrentStackTop].count>
        <cfset variables.parseCurrentStackTop-->
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " :#symbolSymbol#">
        <cfset ArrayAppend(variables.parseSymbols[variables.parseCurrentSymbol][3], obj)>
    <cfelseif char IS "'" AND inString>
        <!--- save the string --->
        <cfset obj = CreateObject("component", "core.String").init(symbol)>
        <cfset ArrayAppend(variables.parseSymbols[variables.parseCurrentSymbol][3], obj)>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " " & symbol>
        <cfset symbol = "">
        <!--- check the top of the stack --->
        <cfif variables.parseStack[variables.parseCurrentStackTop].char IS NOT char>
            <cfthrow message="unmatched '' in function definition...">
        </cfif>
        <cfset variables.symbolSymbol = variables.parseCurrentSymbol>
        <cfset variables.parseCurrentSymbol = variables.parseStack[variables.parseCurrentStackTop].count>
        <cfset variables.parseCurrentStackTop-->
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " :#symbolSymbol#">
        <cfset inString = false>
    <cfelse>
        <cfset symbol &= char>
    </cfif>
    
    <cfoutput>#variables.parseSymbols[variables.parseCurrentSymbol][1]#</cfoutput>
</cfloop>

<cfdump var="#variables.parseSymbols#">
<cfdump var="#variables.parseStack#">
