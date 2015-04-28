<!---
	Name         : constantContact.cfc
	Author       : Eric Ryan Jones aka jonese
	Created      : October 30, 2007
	Last Updated : October 30, 2007
	History      : Initial Generation (10/30/2007)
	Purpose		 : Integrates with Constant Contact API (http://www.constantcontact.com/services/api/index.jsp)
--->

<cfcomponent displayname="ConstantContact" output="false">

	<cfset variables.loginName = "">
    <cfset variables.loginPassword = "">
    <cfset variables.visitorEmail = "">
    <cfset variables.interestCategory = "">
    <cfset variables.baseAddURL = "http://ccprod.roving.com/roving/wdk/API_AddSiteVisitor.jsp">
    <cfset variables.baseRemoveURL = "http://ccprod.roving.com/roving/wdk/API_UnsubscribeSiteVisitor.jsp">
    
    <cffunction name="init" access="public" returntype="constantContact" output="false">
        <cfargument name="login" type="string" required="true">
        <cfargument name="password" type="string" required="true">
        
        	<cfset variables.loginName = arguments.login>
           	<cfset variables.loginPassword = arguments.password>
        <cfreturn this>
    </cffunction>
    
    <cffunction name="processRequest" access="private" returntype="struct" output="no">
    	<cfargument name="processURL" type="string" required="yes" displayname="URL to send to Constant Contact">
        <cfset var errorMessageRaw = ''>
        <cfset var errorMessageClean = ''>
        <cfset var returnStruct = structNew()>
        <cfset var processResult = ''>
        <cftry>
        	<cfif server.ColdFusion.ProductVersion LT 7>
            	<cfhttp method="get" url="#arguments.processURL#" resolveurl="no" throwonerror="no" redirect="yes"></cfhttp>
                <cfset processResult = cfhttp>
			<cfelse>
	            <cfhttp method="get" url="#arguments.processURL#" result="processResult" resolveurl="no" throwonerror="no" redirect="yes"></cfhttp>
			</cfif>
	        
            <cfif processResult.responseHeader.status_code EQ 200>
                <cfif left(trim(processResult.Filecontent),3) EQ 500>
                	<cfset errorMessageRaw = trim(listFirst(processResult.Filecontent,':'))>
                	<cfset errorMessageClean = trim(mid(errorMessageRaw,4,len(errorMessageRaw)))>
                    <cfset returnStruct.success = false>
                    <cfset returnStruct.message = errorMessageClean>
				<cfelseif left(trim(processResult.Filecontent),1) EQ 0>
    	            <cfif Len(Trim(processResult.Filecontent)) GT 1>
						<cfset returnStruct.success = true>
                        <cfset returnStruct.message = trim(mid(processResult.Filecontent,2,len(processResult.Filecontent)))>
					<cfelse>
						<cfset returnStruct.success = true>
                        <cfset returnStruct.message = "email address has been processed">
					</cfif>
				</cfif>		
			</cfif>
        	<cfcatch type="any">
            	<cfrethrow>
            </cfcatch>
        </cftry>
        
        <cfreturn returnStruct>
    </cffunction>

	<cffunction name="addUpdateSubscriber" access="public" returntype="struct" output="no">
    	<cfargument name="visitorEmail" type="string" required="yes">
    	<cfargument name="interestCategory" type="string" required="yes">
    	<cfargument name="first_name" type="string" required="no">
    	<cfargument name="middle_name" type="string" required="no">
    	<cfargument name="last_name" type="string" required="no">
    	<cfargument name="job_title" type="string" required="no">
    	<cfargument name="company_name" type="string" required="no">
    	<cfargument name="work_phone" type="string" required="no">
    	<cfargument name="home_phone" type="string" required="no">
    	<cfargument name="address_line_1" type="string" required="no">
    	<cfargument name="address_line_2" type="string" required="no">
    	<cfargument name="address_line_3" type="string" required="no">
    	<cfargument name="city" type="string" required="no">
    	<cfargument name="state" type="string" required="no">
    	<cfargument name="country" type="string" required="no">
    	<cfargument name="postal_code" type="string" required="no">
    	<cfargument name="sub_postal_code" type="string" required="no">
    	<cfargument name="custom_field_1" type="string" required="no">
    	<cfargument name="custom_field_2" type="string" required="no">
    	<cfargument name="custom_field_3" type="string" required="no">
    	<cfargument name="custom_field_4" type="string" required="no">
    	<cfargument name="custom_field_5" type="string" required="no">
        
        <cfset var addResult = structNew()>
        
        <!--- Add required params to url string --->
        <cfset var submissionURL = variables.baseAddURL & '?loginName=' & urlEncodedFormat(variables.loginName) & '&loginPassword=' & urlEncodedFormat(variables.loginPassword)>
        <cfset submissionURL = submissionURL & '&ea=' & urlEncodedFormat(arguments.visitorEmail) & '&ic=' & urlEncodedFormat(arguments.interestCategory)>
        
        <!--- Add options params to url string --->
        <cfif isDefined('arguments.first_name') AND Len(Trim(arguments.first_name))>
			<cfset submissionURL = submissionURL & '&first_name=' & urlEncodedFormat(arguments.first_name)>
		</cfif>
        <cfif isDefined('arguments.middle_name') AND Len(Trim(arguments.middle_name))>
			<cfset submissionURL = submissionURL & '&middle_name=' & urlEncodedFormat(arguments.middle_name)>
		</cfif>
        <cfif isDefined('arguments.last_name') AND Len(Trim(arguments.last_name))>
			<cfset submissionURL = submissionURL & '&last_name=' & urlEncodedFormat(arguments.last_name)>
		</cfif>
        <cfif isDefined('arguments.job_title') AND Len(Trim(arguments.job_title))>
			<cfset submissionURL = submissionURL & '&job_title=' & urlEncodedFormat(arguments.job_title)>
		</cfif>
        <cfif isDefined('arguments.company_name') AND Len(Trim(arguments.company_name))>
			<cfset submissionURL = submissionURL & '&company_name=' & urlEncodedFormat(arguments.company_name)>
		</cfif>
        <cfif isDefined('arguments.work_phone') AND Len(Trim(arguments.work_phone))>
			<cfset submissionURL = submissionURL & '&work_phone=' & urlEncodedFormat(arguments.work_phone)>
		</cfif>
        <cfif isDefined('arguments.home_phone') AND Len(Trim(arguments.home_phone))>
			<cfset submissionURL = submissionURL & '&home_phone=' & urlEncodedFormat(arguments.home_phone)>
		</cfif>
        <cfif isDefined('arguments.address_line_1') AND Len(Trim(arguments.address_line_1))>
			<cfset submissionURL = submissionURL & '&address_line_1=' & urlEncodedFormat(arguments.address_line_1)>
		</cfif>
        <cfif isDefined('arguments.address_line_2') AND Len(Trim(arguments.address_line_2))>
			<cfset submissionURL = submissionURL & '&address_line_2=' & urlEncodedFormat(arguments.address_line_2)>
		</cfif>
        <cfif isDefined('arguments.address_line_3') AND Len(Trim(arguments.address_line_3))>
			<cfset submissionURL = submissionURL & '&address_line_3=' & urlEncodedFormat(arguments.address_line_3)>
		</cfif>
        <cfif isDefined('arguments.city') AND Len(Trim(arguments.city))>
			<cfset submissionURL = submissionURL & '&city=' & urlEncodedFormat(arguments.city)>
		</cfif>
        <cfif isDefined('arguments.state') AND Len(Trim(arguments.state))>
			<cfset submissionURL = submissionURL & '&state=' & urlEncodedFormat(arguments.state)>
		</cfif>
        <cfif isDefined('arguments.country') AND Len(Trim(arguments.country))>
			<cfset submissionURL = submissionURL & '&country=' & urlEncodedFormat(arguments.country)>
		</cfif>
        <cfif isDefined('arguments.postal_code') AND Len(Trim(arguments.postal_code))>
			<cfset submissionURL = submissionURL & '&postal_code=' & urlEncodedFormat(arguments.postal_code)>
		</cfif>
        <cfif isDefined('arguments.sub_postal_code') AND Len(Trim(arguments.sub_postal_code))>
			<cfset submissionURL = submissionURL & '&sub_postal_code=' & urlEncodedFormat(arguments.sub_postal_code)>
		</cfif>
        <cfif isDefined('arguments.custom_field_1') AND Len(Trim(arguments.custom_field_1))>
			<cfset submissionURL = submissionURL & '&custom_field_1=' & urlEncodedFormat(arguments.custom_field_1)>
		</cfif>
        <cfif isDefined('arguments.custom_field_2') AND Len(Trim(arguments.custom_field_2))>
			<cfset submissionURL = submissionURL & '&custom_field_2=' & urlEncodedFormat(arguments.custom_field_2)>
		</cfif>
        <cfif isDefined('arguments.custom_field_3') AND Len(Trim(arguments.custom_field_3))>
			<cfset submissionURL = submissionURL & '&custom_field_3=' & urlEncodedFormat(arguments.custom_field_3)>
		</cfif>
        <cfif isDefined('arguments.custom_field_4') AND Len(Trim(arguments.custom_field_4))>
			<cfset submissionURL = submissionURL & '&custom_field_4=' & urlEncodedFormat(arguments.custom_field_4)>
		</cfif>
        <cfif isDefined('arguments.custom_field_5') AND Len(Trim(arguments.custom_field_5))>
			<cfset submissionURL = submissionURL & '&custom_field_5=' & urlEncodedFormat(arguments.custom_field_5)>
		</cfif>
        
		<cfset addResult = processRequest(submissionURL)>
        
        <cfreturn addResult>
        
    </cffunction>

	<cffunction name="removeSubscriber" access="public" returntype="struct" output="no">
    	<cfargument name="visitorEmail" type="string" required="yes">
       
        <cfset var removeResult = structNew()>
        
        <!--- Add required params to url string --->
        <cfset var submissionURL = variables.baseRemoveURL & '?loginName=' & urlEncodedFormat(variables.loginName) & '&loginPassword=' & urlEncodedFormat(variables.loginPassword)>
        <cfset submissionURL = submissionURL & '&ea=' & urlEncodedFormat(arguments.visitorEmail)>
        
		<cfset removeResult = processRequest(submissionURL)>
        
        <cfreturn removeResult>
        
    </cffunction>
</cfcomponent>