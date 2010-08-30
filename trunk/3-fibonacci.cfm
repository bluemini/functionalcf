<!--- fibonacci uses recursion --->
<cfset G("defn fib [num] (if (lEQ num 1) 1 (fib (sub num 1)) 1)")>

<cffunction name="G">
    <cfargument name="inst">
    
    <cfset stack = arrayNew(1)>
    <cfset tokens = arrayNew(1)>
</cffunction>