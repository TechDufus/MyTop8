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

    # $SectionToReplace = $ProfileContent[$StartIndex..$EndIndex] | Out-String
    $ReplaceWith = '# Hello There!'
    ($StartIndex+1)..($EndIndex-1) | Foreach-Object {
        $ProfileContent[$_].Replace($ProfileContent[$_], $ReplaceWith)
    }
}