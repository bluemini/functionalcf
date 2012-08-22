<!--- mangle is a test function that does a sum on args that are mangled first --->

<cfset $("defn mangle [value-1 value-2] (sum (sub value-1 1) (sum value-2 1))")>

<!--- now run it with (4 5) which should give you the sum of (4-1)+(5+1) which will be 9 --->
<cfset $("mangle 4 5")>