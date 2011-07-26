<cfcomponent extends="func" implements="IRunnable">
    
    <cfset variables.expression = "">
    <cfset variables.args = ArrayNew(1)>

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="inputData" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("If", arguments.inputData, arguments.scope)>
        
        <!--- ensure that there are at least two entries --->
        <cfif variables.inputData.length() LT 2>
            <cfthrow message="IF requires at least two arguments (expression true [false])">
        </cfif>
        
        <!--- the first argument is the expression that IF will evaluate, to extract it and
        create an instance of the function --->
        <cfset variables.expression = variables.inputData.first()>
        
        <cfset variables.args = variables.inputData.rest()>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        <cfargument name="bindMap" type="struct" required="true">
        
        <!--- get the response from running the first argument --->
        <cfset var check = variables.expression.run(arguments.bindMap, variables.scope)>
        
        <cfif url.debug>
            <strong>IF</strong>.run()<br>
            <cfoutput>condition of IF found to be #check#<br></cfoutput>
        </cfif>
        
        <cfif check>
            <cfreturn variables.args.first().run(arguments.bindMap, variables.scope)>
        <cfelse>
            <cfif variables.args.length() GTE 2>
                <cfreturn variables.args.rest().first().run(arguments.bindMap, variables.scope)>
            <cfelse>
                <cfreturn false>
            </cfif>
        </cfif>
    </cffunction>

</cfcomponent>