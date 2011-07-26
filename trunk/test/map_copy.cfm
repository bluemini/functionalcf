<cfset objInt = CreateObject("component", "map_copy")>
<cfset objInt.setValue(20)>

<cfset one = StructNew()>
<cfset one["value-1"] = objInt>

<cfset two = Duplicate(one)>
<cfset objInt.setValue(30)>

<cfdump var="#one#">
<cfdump var="#two#">