# Exchange 2010 SP2
# Search all mailboxes for a LIKE match on an SMTP email address
# Input:   String to search for
# Returns: Object of (user principal name, smtp alias) for each match

param	($sAliasSnip = "-----")

function fGetSmtpEmailAliases($oUserMb) {
    $aReturned = @()
	$oUserMb.EmailAddresses | ForEach-Object {
	    if ( $_.prefix.DisplayName -imatch 'SMTP' ) {
            $aReturned += $_.SmtpAddress
		}
	}
	return ,$aReturned
}
Get-Mailbox -ResultSize unlimited | ForEach-Object { 
    $oMb = $_
    $aAliases = fGetSmtpEmailAliases $oMb  # Must save to variable, can't pass array down pipline.  WHY PS?
    $aAliases | ForEach-Object {
        $sAlias = $_
        if ($sAlias -imatch $sAliasSnip) {
        	$oReturned = New-Object -TypeName System.Management.Automation.PSObject
        	Add-Member -InputObject $oReturned -MemberType NoteProperty -Name User -Value $oMb.UserPrincipalName
        	Add-Member -InputObject $oReturned -MemberType NoteProperty -Name Alias -Value $sAlias
            $oReturned
        }
    }

}
    