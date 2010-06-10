<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Functional Programming in CF</title>
</head>

<body>
<!--- <cfset $(defn, "hello", "Says hello to whomever you pass it..", "[name]", [println, "Hello, ", "name"])> --->
<h3>Calling $(println, "hello", "bob")</h3>
<cfscript>
	$(println, "hello, ", "bob");
</cfscript>

<!---
for this try, 
	defn:			the define function
	"hello"			the name of the function we are defining
	"says hello"	a document comment
	"[name]"		the arguments to pass to the function and map into the function definition
	[println..]		an description of the function. To avoid it being evaluated, it is an implicit array
--->
<h3>Calling $(defn, "myhellofunc", "Says hello", "[name]", [println, "I'd like to say hi to...", "[name]"])</h3>
<cfset $(defn, "myhellofunc", "Says hello", "[name]", [println, "I'd like to say hi to...", "[name]"])>

<h3>Calling $(myhellofunc, "John")</h3>
<cfset $(myhellofunc, "John")>

<!---
<cfset $(defn, "double", "doubles whatever you give it", "[& val]", ["+", "[val]", "[val]"])>

<cfoutput>
	#$(double, 3)#
</cfoutput>
--->
</body>
</html>