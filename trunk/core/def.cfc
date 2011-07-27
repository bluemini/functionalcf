<cfcomponent extends="func" implements="IRunnable">

	<cffunction name="init" output="true" hint="Allows you to define a function" returntype="any">
        <cfargument name="inputData" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
	    <cfset var arrKeys = structKeyArray(arguments)>
	    <cfset var arrKey = 0>
	    <cfset var attr = {}>
	    <cfset var arityCount = 1>
        <cfset var argData = inputData._getData()>
	    <cfset attr.func = arrayNew(1)>
	    <cfset attr.comment = "">
                    
        <cfset super.init("def", arguments.inputData, arguments.scope)>
        
	    <cfreturn this>
	</cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
		<cfset var main = variables.inputData>
        <cfset var structure = "">
        
        <cfif main.length() EQ 2>
            
            <!--- construct the body --->
            <cfset structure = main.rest().first()>
            <cfset structure.name = main.first().data>
            
        <cfelse>
            <cfthrow message="Unable to define a function. DEF must be called with two args; name and data">
        </cfif>
        
        <cfreturn structure>
    </cffunction>
    
</cfcomponent>