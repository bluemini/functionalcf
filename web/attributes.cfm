<!--- builds the request, session, and other stuff into CFn structures --->

<cfset headers = GetHttpRequestData()>
<cfset headerString = "'accept">
<cfdump var="#headers#"><cfabort>