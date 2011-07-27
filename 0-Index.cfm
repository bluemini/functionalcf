<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Functional Programming in CF</title>
</head>

<body>

<h3>Calling $("str 'hello' 'bob'")</h3>
<cfset $('str "hello " "bob"')>

<h3>Calling $("defn myhellofunc [name] (str 'Id like to say hi to...' name))</h3>
<cfset $("defn myhellofunc [name] (str ""Id like to say hi to..."" name)")>

<h3>Calling $("myhellofunc 'John'")</h3>
<cfset $("myhellofunc ""John""")>

<!---
<cfset $(defn, "double", "doubles whatever you give it", "[& val]", ["+", "[val]", "[val]"])>

<cfoutput>
	#$(double, 3)#
</cfoutput>
--->
</body>
</html>