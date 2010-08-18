<!--- fibonacci uses recursion --->
<cfset $(defn, "fib", "",
	[if, [gt, "num", 1],
		 [fib, [sub, num, 1]],
		 1])>