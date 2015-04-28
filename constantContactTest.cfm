<cfscript>
	contactObj = CreateObject('component','constantContact');
	contactObj.init(login='myLogin',password='myPassword');
	addit = contactObj.addUpdateSubscriber(visitorEmail='support.dot.test@dot.test.example.com',interestCategory='List Name');
	removeit = contactObj.removeSubscriber(visitorEmail='noreply@example.com');
</cfscript>
<cfdump var="#addit#" label="add it">
<cfdump var="#removeit#" label="remove it">