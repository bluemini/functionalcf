<cfcomponent>
    
    <cfset this.name = "undefined">
	
	<!---
	func is an array of function definitions. If there are more than one, then
	the first argument
	--->
	
	<cfset variables.argArray = arrayNew(1)>
	<cfset variables.parseStack = ArrayNew(1)>
	<cfset variables.parseSymbols = ArrayNew(1)>
	<cfset variables.parseCurrentSymbol = "">
	<cfset variables.parseCurrentStackTop = 0>
	
    <!---
        Initialise the func with a 
        name:Struct
            Comment:        text description of the function - not required
            Func:           array of at least one record that defines the function body
            Name:           the name of the function, by which it will be called
        
        scope:Object
            An object against which the function will be called.
    --->
	<cffunction name="init">
        <cfargument name="name">
		<cfargument name="inputData">
		<cfargument name="scope">
        
		<cfset variables.name = arguments.name>
        <cfset variables.inputData = arguments.inputData>
		<cfset variables.scope = arguments.scope>
		
        <cfset variables.meta.symbolTable = StructNew()>
        <cfset variables.meta.symbolCount = 0>

		<!--- if args were passed in, then store them locally in an array --->
		<!--- <cfset processArgs(arguments.contents)> --->
		
        <!--- parse the incoming string into a symbol tree
        <cfset parse(contents._getData(), variables.meta)>
         --->
        
	</cffunction>
	
	<cffunction name="run">
		<cfset var argMatch = arrayNew(1)>
		<cfset var dynCounter = 1>
		<cfset var newArgs = {}>
        
        HERE in func.run()
        <cfabort>
		
		<cfif request.debug>--- running ---<br>
		<cfdump var="#arguments#" label="FUNC RUN"></cfif>
		<cfoutput>
			
		<!--- find the function definition associated with the number of args passed in --->
		<cfset numArgs = arrayLen(arguments)>
		<cfset funcDecl = 0>
		<cfloop from="1" to="#arrayLen(variables.attr.func)#" index="iDecl">
			<cfif isSimpleValue(variables.attr.func[iDecl][1]) AND listLen(stripDynArg(variables.attr.func[iDecl][1])) EQ numArgs>
				<cfset funcDecl = variables.attr.func[iDecl][2]>
				<cfbreak>
			<cfelseif isObject(variables.attr.func[iDecl][1]) OR isCustomFunction(variables.attr.func[iDecl][1])>
				<cfset funcDecl = variables.attr.func[iDecl]>
				<cfbreak>
			</cfif>
		</cfloop>
		
		<cfif request.debug>
			<cfdump var="#funcDecl#" label="FUNC function definition">
		</cfif>
		<!---
		<cfif isSimpleValue(variables.attr.func[1][1])><cfoutput>#listLen(variables.attr.func[1][1])#, #numArgs#</cfoutput><cfelse>NOPE</cfif>
		--->
		
		<cfif NOT isArray(funcDecl)>Ooops, no function definition found in <cfdump var="#variables.attr.func#"><cfabort></cfif>
		
		<!--- loop over each argument from the definition (variables.attr.args) and
		and add to 
		--->
		
		<cfloop from="2" to="#arrayLen(funcDecl)#" index="iValue">
			<cfset argValue = funcDecl[iValue]>
			<cfif isDynArg(argValue)>
				<!--- the argument needs to be dynamically evaluated --->
				<cfif arrayLen(arguments) GTE dynCounter>
					<cfset arrayAppend(argMatch, arguments[dynCounter])>
					<cfset dynCounter++>
				<cfelse>
					<cfthrow message="Not enough arguments supplied to function">
				</cfif>
			<cfelse>
				<cfset arrayAppend(argMatch, argValue)>
			</cfif>
			<!--- <cfset argMatch[variables.argArray[dynCounter]] = argValue> --->
		</cfloop>
		<cfif request.debug><cfdump var="#argMatch#" label="ARGMATCH"></cfif>
		
		<!--- assemble the array into an argument collection --->
		<cfset newArgs["arg1"] = funcDecl[1]>
		<cfloop from="1" to="#arrayLen(argMatch)#" index="iArgMatch">
			<cfset newArgs["arg#iArgMatch+1#"] = argMatch[iArgMatch]>
		</cfloop>
		
		<cfif request.debug>
			--- Calling our defined function ---<cfdump var="#newArgs#" label="FUNC argumentCollection">
		</cfif>
		<cfset variables.that.$(argumentCollection=newArgs)>
		</cfoutput>
	</cffunction>
	
    <!--- ensure that the args are identifiers (ie not place holders) --->
	<cffunction name="isDynArg">
		<cfargument name="toCheck">
        
        <cftry>
            <cfset var item = toCheck.first()>
            <cfcatch><cfdump var="#toCheck#"></cfcatch>
        </cftry>
        <cfloop condition="item IS NOT ''">
            <cfoutput>item: #item#<br></cfoutput>
            <cfif Len(item) LTE "" OR Left(item, 1) IS ":">
                <cfreturn false>
            </cfif>
            <cfset toCheck = toCheck.rest()>
            <cfset item = toCheck.first()>
        </cfloop>
		<cfreturn false>
	</cffunction>

	<cffunction name="stripDynArg">
		<cfargument name="toCheck">
		<cfif isDynArg(toCheck)>
			<cfreturn mid(toCheck, 1, len(toCheck)-2)>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="parse" output="false">
        <cfargument name="codeString">
        <cfargument name="meta">
    
        <cfset var obj = {}>
        <cfset var tempCodeString = "">
        <cfset var codeLen = Len(arguments.codeString)>
        <cfset var count = 0>
		<cfset var char = "">
		<cfset var symCount = 1>
		<cfset var inString = false>
		
		<cfset variables.parseCurrentSymbol = 1>
		<cfset variables.parseSymbols[variables.parseCurrentSymbol] = ArrayNew(1)>
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] = "">
        <cfset variables.parseSymbols[variables.parseCurrentSymbol][2] = "BASE">
    
        <cfdump var="#variables.meta#">
        <cfoutput>Parsing: '#codeString#'<br/>  </cfoutput>

        <!--- move over the text and tokenise as we go --->
		<cftry>
		<cfloop from="1" to="#codeLen#" index="count">
            <cfset char = mid(codeString, count, 1)>
			<cfoutput><br>#char#</cfoutput>
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
				<cfset inString = true>
                <cfdump var="#variables.parseSymbols#">
                <cfdump var="#variables.parseStack#">
            <cfelseif char IS "]">
                <!--- check the top of the stack --->
				<cfif variables.parseStack[variables.parseCurrentStackTop].char IS NOT char>
				    <cfthrow message="unmatched [] in function definition...">
				</cfif>
                <cfset variables.symbolSymbol = variables.parseCurrentSymbol>
                <cfset variables.parseCurrentSymbol = variables.parseStack[variables.parseCurrentStackTop].count>
                <cfset variables.parseCurrentStackTop-->
                <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " :#symbolSymbol#">
            <cfelseif char IS ")">
                <!--- check the top of the stack --->
                <cfif variables.parseStack[variables.parseCurrentStackTop].char IS NOT char>
                    <cfthrow message="unmatched () in function definition...">
                </cfif>
                <cfset variables.symbolSymbol = variables.parseCurrentSymbol>
                <cfset variables.parseCurrentSymbol = variables.parseStack[variables.parseCurrentStackTop].count>
                <cfset variables.parseCurrentStackTop-->
                <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= " :#symbolSymbol#">
            <cfelseif char IS "'" AND inString>
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
                <cfset variables.parseSymbols[variables.parseCurrentSymbol][1] &= char>
			</cfif>
			
			<cfoutput>#variables.parseSymbols[variables.parseCurrentSymbol][1]#</cfoutput>
		</cfloop>
            <cfcatch>
                <cfdump var="#variables.parseSymbols#">
                <cfdump var="#variables.parseStack#">
                <cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>

    <!--- parses a string argument into a structured nested execution tree --->
    <cffunction name="parse_old">
        <cfargument name="codeString">
        <cfargument name="meta">
    
        <cfset var obj = {}>
        <cfset var tempCodeString = "">
        <cfset var openingParen = 0>
        <cfset var closingParen = 0>
		<cfset var startFind = 0>
		<cfset var count = 0>
    
        <cfdump var="#variables.meta#">
        <cfoutput>Parsing: '#codeString#'<br/>  </cfoutput>
    
        <!--- treat any enclosing parantheses --->
        <cfset openingParen = find("(", codeString, startFind)>
		<cfset openingSquare = find("[", codeString, startFind)>
		<cfset openingQuote = Find("'", codeString, startFind)>
		<cfset level = getLowest(openingParen, openingSquare, openingQuote)>		

        <!--- move through the string --->
		<cfloop condition="level GT 0 AND count LT 10">
	        <cfif level EQ 1>
	            <cfset closingParen = find(")", reverse(codeString))>
	            <cfif closingParen EQ 0><cfthrow message="Unmatched parentheses in expression '#codeString#"></cfif>
	
	            <cfoutput>Making a list of #codestring#/#meta.symbolCount#<br></cfoutput>
	            <cfset encFunc = parse(mid(codeString, openingParen+1, len(codeString)-closingParen-openingParen), meta)>
	            
	            <!--- reform codestring --->
	            <cfif openingParen GT 1><cfset tempCodeString = tempCodeString & left(codeString, openingParen-1)></cfif>
	            <cfset tempCodeString = tempCodeString & " :sym#meta.symbolCount# ">
	            <cfif closingParen GT 1><cfset tempCodeString = tempCodeString & right(codeString, closingParen-1)></cfif>
	            <cfset codeString = tempCodeString>
	            
	            <cfoutput>Storing the list object in symbolTable<br></cfoutput>
	            
	            <cfset obj = createObject("component", "List").init(codeString)>
	            <cfset meta.symbolTable['sym#meta.symbolCount#'] = obj>
	            <cfset meta.symbolCount ++>
	            <cfset startFind = openingParen+1>
	
	        <cfelseif level EQ 2>
	            <cfset closingSquare = find("]", reverse(codeString))>
	            <cfif closingSquare EQ 0><cfthrow message="Unmatched parentheses in expression '#codeString#"></cfif>
	
	            <cfoutput>Making a list of #codestring#/#meta.symbolCount#<br></cfoutput>
	            <cfset encFunc = parse(mid(codeString, openingSquare+1, len(codeString)-closingSquare-openingSquare), meta)>
	            
	            <!--- reform codestring --->
	            <cfif openingSquare GT 1><cfset tempCodeString = tempCodeString & left(codeString, openingSquare-1)></cfif>
	            <cfset tempCodeString = tempCodeString & " :sym#meta.symbolCount# ">
	            <cfif closingSquare GT 1><cfset tempCodeString = tempCodeString & right(codeString, closingSquare-1)></cfif>
	            <cfset codeString = tempCodeString>
	            
	            <cfoutput>Storing the list object in symbolTable<br></cfoutput>
                <cfset obj = createObject("component", "List").init(codeString)>
	            <cfset meta.symbolTable['sym#meta.symbolCount#'] = obj>
	            <cfset meta.symbolCount ++>
                <cfset startFind = openingSquare+1>
	
	        <cfelseif level EQ 1>
	            <cfset closingQuote = find("'", reverse(codeString))>
	            <cfif closingQuote EQ 0><cfthrow message="Unmatched parentheses in expression '#codeString#"></cfif>
	
	            <cfoutput>Making a list of #codestring#/#meta.symbolCount#<br></cfoutput>
	            <cfset encFunc = parse(mid(codeString, openingQuote+1, len(codeString)-closingQuote-openingQuote), meta)>
	            
	            <!--- reform codestring --->
	            <cfif openingQuote GT 1><cfset tempCodeString = tempCodeString & left(codeString, openingQuote-1)></cfif>
	            <cfset tempCodeString = tempCodeString & " :sym#meta.symbolCount# ">
	            <cfif closingQuote GT 1><cfset tempCodeString = tempCodeString & right(codeString, closingQuote-1)></cfif>
	            <cfset codeString = tempCodeString>
	            
	            <cfoutput>Storing the list object in symbolTable<br></cfoutput>
                <cfset obj = createObject("component", "List").init(codeString)>
	            <cfset meta.symbolTable['sym#meta.symbolCount#'] = obj>
	            <cfset meta.symbolCount ++>
                <cfset startFind = openingQuote+1>
	
	        </cfif>
    
            <!--- treat any enclosing parantheses --->
            <cfset openingParen = find("(", codeString, startFind)>
            <cfset openingSquare = find("[", codeString, startFind)>
            <cfset openingQuote = Find("'", codeString, startFind)>
            <cfset level = getLowest(openingParen, openingSquare, openingQuote)>    
			<cfset count = count + 1>
			    
	    </cfloop>
    
        <!--- <cfloop list="#arguments.codeString#" index="symbol">
        <cfif left(symbol, 1) IS "(">
            <cfset execTree[index] = parse(mid(codeString,))>
        </cfif>
        </cfloop> --->
        <cfoutput>#level#, #codeString#<br></cfoutput>
        <cfset obj = createObject("component", "List").init(codeString)>
        <cfset meta.symbolTable['sym#meta.symbolCount#'] = obj>
        <cfset meta.symbolCount ++>

        <cfreturn obj>
    </cffunction>
    
    <cffunction name="evaluateTree">
        <cfthrow message="This method must be overridden">
    </cffunction>
	
    <cffunction name="getLowest">
        <cfargument name="one">
        <cfargument name="two">
        <cfargument name="three">
		
		<cfset var lowest = one>
		
		<cfif one EQ 0>
            <cfif two EQ 0>
                <cfif three EQ 0>
				    <cfreturn 0>
				<cfelse>
				    <cfreturn 3>
				</cfif>
			<cfelse>
                <cfif three EQ 0>
				    <cfreturn 2>
				<cfelseif three GT two>
				    <cfreturn 2>
				<cfelse>
				    <cfreturn 3>
				</cfif>
            </cfif>
        <cfelse>
            <cfif two EQ 0>
			    <cfif three EQ 0>
				    <cfreturn 1>
				<cfelseif three GT one>
				    <cfreturn 1>
				<cfelse>
				    <cfreturn 3>
				</cfif>
            <cfelse>
			    <cfif three EQ 0>
				    <cfif one GT two>
					    <cfreturn 2>
					<cfelse>
					    <cfreturn 1>
					</cfif>
                <cfelse>
				    <cfif one LT two AND one LT three>
					    <cfreturn 1>
					<cfelseif two LT one AND two LT three>
					    <cfreturn 2>
					<cfelse>
					    <cfreturn 3>
					</cfif>
				</cfif>
    		</cfif>
        </cfif>
	</cffunction>

</cfcomponent>