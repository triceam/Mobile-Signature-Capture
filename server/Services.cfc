<cfcomponent>
	
    <cffunction name="submitSignature" access="remote" returntype="boolean">
		<cfargument name="email" type="string" required="yes">
		<cfargument name="signature" type="string" required="yes">
        
        <cfmail SUBJECT ="Signature"
            FROM="#fromEmailAddress#"
            TO="#email#"
            username="#emailLoginUsername#"
            password="#emailLoginPassword#"
            server="#mailServer#" type="HTML" >
            
            <p>This completes the form transaction for <strong>#email#</strong>.</p>
            
            <p>You may view your signature below:</p>
            <p><img src="cid:signature" /></p>
            
            <p>Thank you for your participation.</p>
            
            <cfmailparam
                file="signature"
                content="#toBinary( signature )#"
                contentid="signature"
                disposition="inline" />
        
        </cfmail>

        <cfreturn true />

    </cffunction>
    
</cfcomponent>
