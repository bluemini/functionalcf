<!--- test the if form --->
<cfset $("if false (pr 'hello') (pr 'it was false ::')")>

<p>Next 2 results should be: 4 and 16</p>
<cfset $("sum 1 3")>
<cfset $("sum 4 12")>

<cfabort>
<!---


<p>Next 2 results should be: 2 and -8</p>
<cfset $("sub 5 3")>
<cfset $("sub 4 12")>
--->

<!---
1
1
2
3
5
8
13
21
--->

<!--- fibonacci uses recursion --->
<cfset $("defn fib [num] (if (LT num 2) 1 (sum (fib (sub num 2)) (fib (sub num 1))))")>

<cfset $("fib 4")>