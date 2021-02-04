Param(
    [System.Object] $InputObject
)

# ## You interface with the Actions/Workflow system by interacting
# ## with the environment.  The `GitHubActions` module makes this
# ## easier and more natural by wrapping up access to the Workflow
# ## environment in PowerShell-friendly constructions and idioms
# if (-not (Get-Module -ListAvailable GitHubActions)) {
#     ## Make sure the GH Actions module is installed from the Gallery
#     Install-Module GitHubActions -Force
# }

# ## Load up some common functionality for interacting
# ## with the GitHub Actions/Workflow environment
# Import-Module GitHubActions


# $inputs = @{
#     users_list        = Get-ActionInput users_list
#     readme_path       = Get-ActionInput readme_path
#     commit_message    = Get-ActionInput commit_message
#     commiter_username = Get-ActionInput commiter_username
#     commiter_email    = Get-ActionInput commiter_email
# }

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
        [System.String[]]
        $Users
    )

    Process {
        $Users = $Users.Split()
        If ($Users.Count -gt 8) {
            Throw "YOU NEED NO MORE THAN 8 USERS PLEASE!"
        }
        $OutputMyTop8 = [System.Text.StringBuilder]::new()
        $null=$OutputMyTop8.AppendLine('<!-- MYTOP8-LIST:START -->')
        $null=$OutputMyTop8.AppendLine('<table style="border-collapse: collapse;" border="1"><tbody>')
        for ($i = 0; $i -lt $Users.Count; $i++) {
            $null=$OutputMyTop8.AppendLine("<td style=''><p><a href='https://github.com/$($Users[$i])'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/$($Users[$i]).png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>$($i + 1). <a href='https://github.com/$($Users[$i])'>$($Users[$i])</a></p></td>")
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

#Region Commit-GitRepo

Function Commit-GitRepo() {
    [CmdletBinding()]
    Param()

    Process {
        git config --local user.name "$env:COMMITTER_USERNAME"
        git config --local user.email "$env:COMMITTER_EMAIL"

        git add .
        git commit -m "$env:COMMIT_MESSAGE"
        git push
    }
}
#EndRegion Commit-GitRepo

Get-ChildItem Env:
Get-Variable

$InputObject | Get-Member
$ProfileContent = Get-Content -Path $inputs.readme_path

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
    Users = $env:USERS_LIST
}

$GeneratedTop8Section = Get-CurrentTop8Section @getCurrentTop8SectionSplat

Compare-Object -ReferenceObject $CurrentSection -DifferenceObject $GeneratedTop8Section -PassThru
# $AssembledProfile = $PreSectionContent,,$PostSectionContent | Out-String
# $ProfileContentString = $ProfileContent | Out-String



# If ($AssembledProfile -eq $ProfileContentString) {
#     "They are the same, no changes need to be made"
# } Else {
#     "Need to publish new profile for New Top8 Content."
#     "git commit -m 'New MyTop8 Content'"
#     "git push"
# }

