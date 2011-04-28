<cfcomponent extends="func" implements="IRunnable">
    
    <cfset variables.expression = "">
    <cfset variables.args = ArrayNew(1)>

    <cffunction name="init" returntype="any" output="true">
        <cfargument name="contents" type="any" hint="accepts a list object of the function body..">
        <cfargument name="scope" default="this" type="any">
        
        <cfset super.init("If", arguments.contents, this)>
        
        <!--- ensure that there are at least two entries --->
        <cfif contents.length() LT 3>
            <cfthrow message="IF requires at least two arguments (expression true [false])">
        </cfif>
        
        <!--- the first argument is the expression that IF will evaluate, to extract it and
        create an instance of the function --->
        <cfset variables.expression = variables.contents.first()>
        
        <cfset variables.args = contents.rest()>
        
        <cfreturn this>
    </cffunction>
    
    <cffunction name="evaluateTree">
    </cffunction>
    
    <cffunction name="run">
        <!--- get the response from running the first argument --->
        <cfset var check = variables.expression.run()>
        
        <cfif check>
            <cfreturn variables.args.first().run()>
        <cfelse>
            <cfif variables.args.length() GTE 2>
                <cfreturn variables.args.rest().first().run()>
            <cfelse>
                <cfreturn false>
            </cfif>
        </cfif>
    </cffunction>

</cfcomponent>