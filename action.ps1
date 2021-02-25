using namespace System.Diagnostics.CodeAnalysis

Param(
    [System.Object] $ReadMePath,

    [System.Object] $UsersList,

    [System.Object] $CommitMessage,

    [System.Object] $CommitterUsername,

    [System.Object] $CommitterEmail,

    [ValidateScript({
        If (($_ -gt 150) -OR ($_ -le 0)) {
            $false
        } Else {
            $true
        }
    })]
    [Int] $TableSizePercent
)

Begin {

    #Region Get-PixelLength

    Function Get-PixelLength() {
        [CmdletBinding()]
        Param(
            [Int] $TableSizePercent
        )

        Begin {
            [Int] $DefaultPixelLength = 145
        }

        Process {
            [System.Math]::Round(($TableSizePercent / 100) * $DefaultPixelLength)
        }
    }
    #EndRegion Get-PixelLength

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
            $Users,

            $PixelLength
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
                If ($Users[$i] -eq '--MyspaceTom--') {
                    $null=$OutputMyTop8.AppendLine("<td style=''><p><a href='https://twitter.com/myspacetom'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://pbs.twimg.com/profile_images/1237550450/mstom_400x400.jpg' alt='' width='$PixelLength' height='$PixelLength' /></a></p><p style='text-align: center;'>$($i + 1). <a href='https://twitter.com/myspacetom'>Tom</a></p></td>")
                } Else {
                    $null=$OutputMyTop8.AppendLine("<td style=''><p><a href='https://github.com/$($Users[$i])'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/$($Users[$i]).png' alt='' width='$PixelLength' height='$PixelLength' /></a></p><p style='text-align: center;'>$($i + 1). <a href='https://github.com/$($Users[$i])'>$($Users[$i])</a></p></td>")
                }
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
        [SuppressMessage('PSUseApprovedVerbs', '')]
        Param(
            [Parameter(Mandatory)]
            [System.Object[]] $CommitMessage,
        
            [Parameter(Mandatory)]
            [System.Object[]] $CommitterUsername,
        
            [Parameter(Mandatory)]
            [System.Object[]] $CommitterEmail
        )
    
        Process {
            git config --local user.name "$CommitterUsername"
            git config --local user.email "$CommitterEmail"
    
            git add .
            git commit -m "$CommitMessage"
            git push
        }
    }
    #EndRegion Commit-GitRepo
}

Process {    
    $ProfileContent = Get-Content -Path $ReadMePath
    

    $StartPattern = '<!-- MYTOP8-LIST:START -->'
    $StartIndex = (($ProfileContent | Select-String -Pattern $StartPattern).LineNumber - 1)

    $EndPattern = '<!-- MYTOP8-LIST:END -->'
    $EndIndex = (($ProfileContent | Select-String -Pattern $EndPattern).LineNumber - 1)
    
    #TODO: Create Pre section blanking-out logic if mytop8 starts the file.
    
    $PreSectionContent = $ProfileContent[0..($StartIndex - 1)]
    $CurrentSection = $ProfileContent[$StartIndex..$EndIndex]
    $EndOfFileIndex = ($ProfileContent.Count - 1)
    
    #If section is the end of the file, we need to blank out the Post section.
    If (($EndIndex) -ge $EndOfFileIndex) {
        $PostSectionContent = [System.String]::Empty
    } Else {
        $PostSectionContent = $ProfileContent[($EndIndex + 1)..$EndOfFileIndex]
    }
    $getCurrentTop8SectionSplat = @{
        Users = $UsersList
        PixelLength = Get-PixelLength -TableSizePercent $TableSizePercent
    }
    $GeneratedTop8Section = Get-CurrentTop8Section @getCurrentTop8SectionSplat
    $CurrentSectionString = $CurrentSection | Out-String
    $IsDifferent = for ($i = 0; $i -lt $CurrentSectionString.Length; $i++) {
        If (Compare-Object -ReferenceObject $CurrentSectionString[$i].ToString() -DifferenceObject $GeneratedTop8Section[$i].ToString() -PassThru -ErrorAction SilentlyContinue) {
            $true
            break
        }
    }

    If ($IsDifferent) {
        #Overwrite readme file and commit / push to repo.
        Write-Host "Overwriting profile readme."
        $AssembledProfile = $PreSectionContent,$GeneratedTop8Section,$PostSectionContent | Out-String
        $AssembledProfile | Out-File $ReadMePath -Force

        $commitGitRepoSplat = @{
            CommitMessage     = $CommitMessage
            CommitterUsername = $CommitterUsername
            CommitterEmail    = $CommitterEmail
        }
        Commit-GitRepo @commitGitRepoSplat
    }
}    
