<cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#" name="files">
<cfquery name="files" dbtype="query">select * from files order by name</cfquery>
<ul><cfoutput query="files"><cfif type IS "file" AND (right(name, 4) IS NOT ".cfc"
                                                 AND name IS NOT "index.cfm"
                                                 AND (left(name, 1) IS NOT "_"))>
	<li><a href="#name#">#name#</a></li>
</cfif></cfoutput></ul>