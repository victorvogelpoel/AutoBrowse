function Get-Browser
{
    <#
    .Synopsis
        Gets open browsers
    .Description
        Gets browsers that have already been opened
    .Example
        Get-Browser
    .Link
        Open-Browser
    #>
    param(
    [Switch]
    $Bodyhtml
    )
     
    process {
        (New-Object -ComObject Shell.Application).Windows() | 
            Where-Object { 
                $_.Fullname -and $_.Fullname -like "*iexplore.exe"
            } |
            ForEach-Object {
                if ($Bodyhtml) {
                    $_.Document.body.innerHtml
                } else {
                    $_
                }
            }
    }
} 
