[CmdletBinding()]
Param(
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true,
               Position=0,
               ParameterSetName="Path",
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to one or more locations.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $Path
)

Begin {}

Process {
    $ProfileContent = Get-Content $Path

    #Using BLOG start as a test
    $StartPattern = '<!-- BLOG-POST-LIST:START -->'
    $StartIndex = (($ProfileContent | Select-String -Pattern $StartPattern).LineNumber - 1)
    #Using BLOG end as a test
    $EndPattern = '<!-- BLOG-POST-LIST:END -->'
    $EndIndex = (($ProfileContent | Select-String -Pattern $EndPattern).LineNumber - 1)

    $PreSectionContent = $ProfileContent[0..($StartIndex - 1)]
    $CurrentSection = $ProfileContent[$StartIndex..$EndIndex]
    
    $EndOfFileIndex = ($ProfileContent.Count - 1)
    If (($EndIndex) -ge $EndOfFileIndex) {
        $PostSectionContent = [System.String]::Empty
    } Else {
        $PostSectionContent = $ProfileContent[($EndIndex + 1)..$EndOfFileIndex]
    }

    $AssembledProfile = $PreSectionContent,$CurrentSection,$PostSectionContent | Out-String
    $ProfileContentString = $ProfileContent | Out-String

    If ($AssembledProfile -eq $ProfileContentString) {
        "They are the same, no changes need to be made"
    } Else {
        "Need to publish new profile for New Top8 Content."
        "git commit -m 'New MyTop8 Content'"
        "git push"
    }
}