function Get-GroupChannels{
    param( 
        [Parameter(Position=0, Mandatory=$true)] [string]$MailboxName,
        [Parameter(Position=1, Mandatory=$false)] [psobject]$AccessToken,
        [Parameter(Position=2, Mandatory=$false)] [psobject]$Group,
        [Parameter(Position=3, Mandatory=$false)] [psobject]$ChannelName
    )
    Begin{
        if($AccessToken -eq $null)
        {
              $AccessToken = Get-AccessToken -MailboxName $MailboxName          
        }   
        $HttpClient =  Get-HTTPClient($MailboxName)
        $EndPoint =  Get-EndPoint -AccessToken $AccessToken -Segment "groups"
        if([String]::IsNullOrEmpty($ChannelName)){
            $RequestURL =   $EndPoint + "('" + $Group.Id + "')/channels?`$Top=1000"
        }
        else{
            $RequestURL =   $EndPoint + "('" + $Group.Id + "')/channels?`$filter=displayName eq '$ChannelName'"
        }
        Write-Host $RequestURL        
        do{
            $JSONOutput = Invoke-RestGet -RequestURL $RequestURL -HttpClient $HttpClient -AccessToken $AccessToken -MailboxName $MailboxName
            foreach ($Message in $JSONOutput.Value) {
                Write-Output $Message
            }           
            $RequestURL = $JSONOutput.'@odata.nextLink'
        }while(![String]::IsNullOrEmpty($RequestURL))       
        
        
    }
}