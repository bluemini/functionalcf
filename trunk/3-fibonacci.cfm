<!--- test the if form --->
<cfset $("if false (pr 'hello') (pr 'it was false ::')")>

<!---
<p>Next 2 results should be: 4 and 16</p>
<cfset $("sum 1 3")>
<cfset $("sum 4 12")>

<p>Next 2 results should be: 2 and -8</p>
<cfset $("sub 5 3")>
<cfset $("sub 4 12")>
--->

<!---
0   1
1   1
2   2
3   3
4   5
5   8
6   13
7   21
--->

<!--- fibonacci uses recursion --->
<cfset $("defn fib [num] (if (LT num 2) 1 (sum (fib (sub num 2)) (fib (sub num 1))))")>

<h3>$("fib 4")</h3>
<cfset $("core time (fib 4)")>

<h3>timing $("fib 6")</h3>
<cfset $("core time (fib 6)")>
