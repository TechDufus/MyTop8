[CmdletBinding()]
Param(
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true,
               Position=0,
               ParameterSetName="Path",
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to one or more locations.")]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $Path,

    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true,
               Position=0,
               ParameterSetName="Path",
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to one or more locations.")]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $UsersPath
)

Begin {

    #Region Get-CurrentTop8Section
    
    Function Get-CurrentTop8Section() {
        [CmdletBinding()]
        Param(
            # Specifies a path to one or more locations.
            [Parameter(Mandatory=$true,
                        Position=0,
                        ParameterSetName="Path",
                        ValueFromPipeline=$true,
                        ValueFromPipelineByPropertyName=$true,
                        HelpMessage="Path to one or more locations.")]
            [ValidateNotNullOrEmpty()]
            [System.String]
            $UsersPath,

            [System.String] $GitHubUsername
        )

        Process {
            $UsersList = Get-Content $UsersPath
            If ($UsersList.Count -gt 8) {
                Throw "YOU NEED NO MORE THAN 8 USERS PLEASE!"
            }
            $OutputMyTop8 = [System.Text.StringBuilder]::new()
            $null=$OutputMyTop8.AppendLine('<!-- MYTOP8-LIST:START -->')
            $null=$OutputMyTop8.AppendLine('<table style="border-collapse: collapse;" border="1"><tbody>')
            $null=$OutputMyTop8.AppendLine("<tr><td style='text-align: center' colspan='4'><h1>$GitHubUsername's GitHub Top 8</h1></td></tr>")
            for ($i = 0; $i -lt $UsersList.Count; $i++) {
                $null=$OutputMyTop8.AppendLine("<td style=''><p><a href='https://github.com/$($UsersList[$i])'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/$($UsersList[$i]).png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>$($i + 1). <a href='https://github.com/$($UsersList[$i])'>$($UsersList[$i])</a></p></td>")
                If ($i -eq 3) {
                    $null=$OutputMyTop8.Append('</tr><tr>')
                }
            }
            $null=$OutputMyTop8.AppendLine('</tr></tbody></table>')
            $null=$OutputMyTop8.AppendLine('<!-- MYTOP8-LIST:END -->')
            $OutputMyTop8.ToString()
        }
    }
    #EndRegion Get-CurrentTop8Section
}

Process {
    $ProfileContent = Get-Content $Path

    #Using BLOG start as a test
    $StartPattern = '<!-- MYTOP8-LIST:START -->'
    $StartIndex = (($ProfileContent | Select-String -Pattern $StartPattern).LineNumber - 1)
    #Using BLOG end as a test
    $EndPattern = '<!-- MYTOP8-LIST:END -->'
    $EndIndex = (($ProfileContent | Select-String -Pattern $EndPattern).LineNumber - 1)

    $PreSectionContent = $ProfileContent[0..($StartIndex - 1)]
    $CurrentSection = $ProfileContent[$StartIndex..$EndIndex]
    
    $EndOfFileIndex = ($ProfileContent.Count - 1)
    If (($EndIndex) -ge $EndOfFileIndex) {
        $PostSectionContent = [System.String]::Empty
    } Else {
        $PostSectionContent = $ProfileContent[($EndIndex + 1)..$EndOfFileIndex]
    }

    $getCurrentTop8SectionSplat = @{
        UsersPath = $UsersPath
        GitHubUsername = 'matthewjdegarmo'
    }

    $AssembledProfile = $PreSectionContent,(Get-CurrentTop8Section @getCurrentTop8SectionSplat),$PostSectionContent | Out-String
    $ProfileContentString = $ProfileContent | Out-String

    $AssembledProfile
    # If ($AssembledProfile -eq $ProfileContentString) {
    #     "They are the same, no changes need to be made"
    # } Else {
    #     "Need to publish new profile for New Top8 Content."
    #     "git commit -m 'New MyTop8 Content'"
    #     "git push"
    # }
}
