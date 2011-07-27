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
                    
        <cfset super.init("defn", arguments.inputData, arguments.scope)>
        
	    <cfreturn this>
	</cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
		<cfset var main = variables.inputData>
        <cfset var func = createObject("component", "UserFunc")>
        <cfset var functionBody = ArrayNew(1)>
        <cfset var functionContents = StructNew()>
        
        <cfif main.length() GTE 3>
            <cfset functionName = main.first().data>
            
            <!--- the arguments should be referenced by the second term --->
            <cfset functionArgs = main.rest().first()>
            
            <!--- construct the body --->
            <cfset functionBody = main.rest().rest().first()>
            
            <cfset functionContents.args = functionArgs>
            <cfset functionContents.body = functionBody>
            
            <cfset func.name = functionName>
            <cfset func.setup(functionContents, this)>
            
        <cfelse>
            <cfthrow message="Unable to define a function. DEFN must be called with three args; name, arguments and body">
        </cfif>
        
        <!--- def based forms save their content to the current namespace CurrentNS --->
        <cfset variables.scope[request.currentNS][functionName] = func>
        
        <cfreturn func>
    </cffunction>
    
</cfcomponent>