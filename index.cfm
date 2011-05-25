<cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#" name="files">
<cfquery name="files" dbtype="query">select * from files order by name</cfquery>
<ul><cfoutput query="files"><cfif type IS "file">
	<li><a href="#name#">#name#</a></li>
</cfif></cfoutput></ul>