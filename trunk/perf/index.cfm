<!--- a basic run through of the parsing/running of a function --->

<cfset func = "defn first [coll] (core first coll)">



<cfset time = GetTickCount()>
<cfset $(func)>
<cfoutput>Full parse via $: #GetTickCount()-Time#<br></cfoutput>


<!--- now we'll call each step one at a time and see how it performs --->

<cfset hashId = Hash(func)>



<cfset resp = "">
    
<!--- Since FunctionCF is drawing on the Lisp idea, where even the program code is a list,
we need to create a list from the body text --->
<cfset Time = GetTickCount()>
<cfset baseList = CreateObject("component", "functionalCF.core.List").init(func, cfnScope)>
<cfoutput>List init (parsing): #GetTickCount()-Time#ms<br></cfoutput>



<!--- run the list, which will perform the primary top level function --->
<cfset Time = GetTickCount()>
<cfset out = baseList.run(StructNew(), cfnScope)>
<cfoutput>List run: #GetTickCount()-Time#ms<br></cfoutput>


<!--- if the returned value is a UserFunc object and has a name, then add to variables --->
<cfset Time = GetTickCount()>
<cfif isObject(out)>
    <cfset md = getMetaData(out)>
    <cfif (Len(md.name) GTE 8 AND Right(md.name, 8) IS "UserFunc")>
        <cftry>
            <cfset cfnScope[out.name] = out>
            <cfoutput>> fcf/#out.name#<br></cfoutput>
            <cfcatch><cfrethrow></cfcatch>
        </cftry>
    <cfelseif (Len(md.name) GTE 5 AND Right(md.name, 5) IS ".list")
            OR (Len(md.name) GTE 4 AND Right(md.name, 4) IS ".map")
            OR (Len(md.name) GTE 7 AND Right(md.name, 7) IS ".vector")
            OR (Len(md.name) GTE 4 AND Right(md.name, 4) IS ".set")>
        <cftry>
            <cfset cfnScope[out.name] = out>
            <cfoutput>>c #out.toString()#<br></cfoutput>
            <cfcatch><cfrethrow></cfcatch>
        </cftry>
    
    <cfelseif (Len(md.name) GTE 6 AND Right(md.name, 6) IS ".token")>
        <cftry>
            <cfoutput>>t #out.toString()#<br></cfoutput>
            <cfcatch><cfrethrow></cfcatch>
        </cftry>
    </cfif>
<cfelseif isSimpleValue(out)>
    <cfoutput>>s #out#<br></cfoutput>
</cfif>
<cfoutput>Saving/Output: #GetTickCount()-Time#ms<br></cfoutput>

<cfdump var="#this#">