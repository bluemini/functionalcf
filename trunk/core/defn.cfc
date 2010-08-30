<cfcomponent>

	<cffunction name="init" output="true" hint="Allows you to define a function">
        <cfargument name="terms" type="list">
        
	    <cfset var arrKeys = structKeyArray(arguments)>
	    <cfset var arrKey = 0>
	    <cfset var attr = {}>
	    <cfset var arityCount = 1>
        <cfset var argData = ListToArray(terms._getData(), " ")>
	    <cfset attr.func = arrayNew(1)>
	    <cfset attr.comment = "">
                    
	    <cfdump var="#argData#" label="DEFN arguments">
	    
	    <cfscript>
	        if (arrayLen(argData) LT 2) ;
	        
	        // parse the arguments and set up the new function definition
	        for (i=1; i LTE arrayLen(arrKeys); i++) {
	            argName = argData[i];
	            // the first argument is always the name of the new function
	            if (i EQ 1) {
	                attr.name = argName;
	                if (url.debug) writeOutput("DEFN: function name: <em>"&attr.name&"</em><br>");
	                
	            // if the second term is a simple value (string) and not enclosed in square brackets, then this is the comment
	            } else if (i EQ 2 AND isSimpleValue(argName) AND 
	                (NOT left(argName,1) IS "[" OR NOT right(argName, 1) IS "]")) {
	                attr.comment = argName;
	                if (url.debug) writeOutput("DEFN: function comment: <em>"&attr.comment&"</em><br>");
	            
	            // otherwise the second term will start the real definition
	            } else if (i GTE 2 AND i LTE 3 AND isSimpleValue(argName) AND 
	                left(argName,1) IS "[" AND right(argName, 1) IS "]") {
	                // argMap = createObject("component", "map").init(argName);
	                attr.argmap = argName;
	                if (url.debug) writeOutput("DEFN: argument map defined<br>");
	                
	            // other terms that are arrays are the functional meat of the new function being defined
	            } else if (i GT 1 AND isArray(argName)) {
	                attr.func[arityCount] = argName;
	                arityCount ++;
	            }
	        }
	    </cfscript>
	
	    <cfif url.debug>--- defn attributes ---<br></cfif>
	    <cfset variables[attr.name] = createObject("component", "func").init(attr, this)>
	    <cfif url.debug>--- end defn attributes ---<br></cfif>
	    
	    <!--- return notice that the function was created --->
	    <cfreturn "> user/#attr.name#">
	</cffunction>

</cfcomponent>