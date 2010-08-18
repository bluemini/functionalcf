<cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#" name="files">
<cfoutput query="files">
	<cfif isNumeric(left(name, 1))><a href="#name#">#name#</a><br/></cfif>
</cfoutput>