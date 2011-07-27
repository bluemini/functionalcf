<cfset this.name = "funcex">
<cfset this.sessionManagement = true>

<cfparam name="url.debug" default="false">
<cfparam name="url.explain" default="#url.debug#">

<cffunction name="$" access="public" output="true">
    
    <cfif url.debug>
		<h3>$:</h3>
		<cfdump var="#arguments#" label="arguments (base/$)">
	</cfif>
	
	<cfset resp = "">
	
	<cfif arrayLen(arguments) NEQ 1 OR NOT IsSimpleValue(arguments[1])>
		<cfoutput>FunctionalCF - The argument to $() MUST be a string.</cfoutput>
	<cfelse>
    
        <!--- Since FunctionCF is drawing on the Lisp idea, where even the program code is a list,
        we need to create a list from the body text --->
        <cfset baseList = createObject("component", "List").init(arguments[1])>
        
        <!--- run the list, which will perform the primary top level function --->
        <cfset out = baseList.run(StructNew(), variables)>
        
        <cfif url.debug>
            <cfdump var="#out#" label="out (base)">
        </cfif>
        
        <!--- if the returned value is a UserFunc object and has a name, then add to variables --->
        <cfif isObject(out)>
            <cfset md = getMetaData(out)>
            <cfif (Len(md.name) GTE 8 AND Right(md.name, 8) IS "UserFunc")>
                <cftry>
                    <cfset variables[out.name] = out>
                    <cfoutput>> fcf/#out.name#<br></cfoutput>
                    <cfcatch><cfrethrow></cfcatch>
                </cftry>
            <cfelseif (Len(md.name) GTE 5 AND Right(md.name, 5) IS ".list")
                    OR (Len(md.name) GTE 4 AND Right(md.name, 4) IS ".map")>
                <cftry>
                    <cfset variables[out.name] = out>
                    <cfoutput>>c #out.toString()#<br></cfoutput>
                    <cfcatch><cfrethrow></cfcatch>
                </cftry>
            
            <cfelseif (Len(md.name) GTE 6 AND Right(md.name, 6) IS ".token")>
                <cftry>
                    <cfoutput>>t #out.toString()#<br></cfoutput>
                    <cfcatch><cfrethrow></cfcatch>
                </cftry>
            </cfif>
        <cfelseif isSimpleValue(out)>
            <cfoutput>>s #out#<br></cfoutput>
        </cfif>
        
		<!--- <cfif structKeyExists(arguments, "arg1")>
			<cfset fn = arguments["arg1"]>
		<cfelse>
			<cfset fn = arguments[1]>
		</cfif>
		
		<!--- copy the remaining arguments to a new struct --->
		<cfset newArgs = structNew()>
		<cfset newArgName = 1>
		<cfset arrArgKeys = structKeyArray(arguments)>
		<cfloop from="2" to="#arrayLen(arrArgKeys)#" index="argumentName">
			<cfif structKeyExists(arguments, "arg#argumentName#")>
				<cfset newArgs["arg"&(argumentName-1)] = arguments["arg#argumentName#"]>
			<cfelse>
				<cfset newArgs["arg"&(argumentName-1)] = arguments[argumentName]>
			</cfif>
		</cfloop>
		<cfif url.debug><cfdump var="#newArgs#" label="$ newArgs"></cfif>
		

		
		<cfif structKeyExists(variables, "resp")><cfoutput>#resp#</cfoutput><br></cfif>
		
		<cfif url.debug>--- $ arguments ---<br>
		<cfdump var="#structKeyArray(arguments)#">
		--- end $ arguments ---<br></cfif> --->
	</cfif>
</cffunction>

<cffunction name="onRequest" returntype="void">
	<cfargument name="targetpage" type="any" required="true">
	<cfinclude template="#arguments.targetpage#">
</cffunction>


<cfsilent><cfscript>
// define first
$("defn first [coll] (core first coll)");

// define ffirst
$("defn ffirst [coll] ( first ( first coll))");

// define fffirst
$("defn fffirst [coll] ( first ( first (first coll)))");

// define pr
$("defn pr [string & more] (core out string & more)");

// define sub/sum
$("defn sub [value-1 value-2 & more] (core sub value-1 value-2 & more)");
$("defn sum [value-1 value-2 & more] (core sum value-1 value-2 & more)");
</cfscript></cfsilent>