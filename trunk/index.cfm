<cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#" name="files">
<ul><cfoutput query="files">
	<li><a href="#name#">#name#</a></li>
</cfoutput></ul>