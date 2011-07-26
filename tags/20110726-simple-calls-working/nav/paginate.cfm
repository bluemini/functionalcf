<cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#../" action="list" name="files">
<cfdump var="#getTemplatePath()#">
<cfquery name="sortedfiles" dbtype="query">SELECT * FROM files WHERE type = 'File' ORDER BY name</cfquery>
<cfset last = "">
<cfset prev = "">
<cfset next = sortedFiles["name"][1]>
<cfoutput query="sortedfiles">
	<cfif refind("[0-9]+", name)>
		<cfif prev IS NOT "">
			<cfset next = name>
		</cfif>
		<cfif find(name, getTemplatePath())>
			<cfset prev = last>
		</cfif>
		<cfset last = name>
	</cfif>
</cfoutput>

<cfoutput><!-- about to render next/prev links --><div style="padding:1em 0.5em 0.25em;background-color:##CFC;font-weight:bold;text-decoration:nounderline">
	<cfif prev IS NOT ""><a href="./#prev#" style="float: left">#prev#</a></cfif>
	<cfif next IS NOT "">
		<a href="./#next#" style="float: right">#next#</a>
	<cfelse>
		<a href="./#sortedfiles.name[1]#" style="float: right">start</a>
	</cfif>
	<div style="clear:both"></div>
</div></cfoutput>
