function Invoke-BrowserControl
{
    <#
    .Synopsis
        Clicks or fires events in a browser control.
    .Description
        Clicks or fires events in a browser control, and waits for the change.        
    .Link
        Get-BrowserControl
    #>
    [CmdletBinding(DefaultParameterSetName='Id')]
    [OutputType([PSObject])]
    param(
    # The Browser Object.
    [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
    [ValidateScript({
        if ($_.psobject.typenames -notcontains 'System.__ComObject' -and -not $_.Quit) {
            throw "Not IE"
        }
        $true
    })]
    $IE,
    
    # The timeout to wait for the page to reload after an action 
    [Timespan]$Timeout = "0:0:30",
    
    # The timeout to sleep in between each check to see if the page has reloaded
    [Timespan]$SleepTime = "0:0:0.01",
    
    # The ID of the object within the page    
    [Parameter(Mandatory=$true, ParameterSetName='ById')]
    [string]$Id,
    # The name of the object within the page
    [Parameter(Mandatory=$true, ParameterSetName='ByName')]
    [string]$Name,
    # The tag name of the object within the page
    [Parameter(Mandatory=$true, ParameterSetName='ByTagName')]
    [string]$TagName,
        
    
    # Will find a tag title within items a specific tag
    [string]$TagTitle,
    
    # Will find a link that points to a particular HREF
    [Parameter(Mandatory=$true, ParameterSetName='ByHref')]
    [string]$Href,
    
    # The property of the document object
    [Parameter(Mandatory=$true, ParameterSetName='ByInnerText')]
    [string]$DocumentProperty,
    # The inner text to find.
    [Parameter(Mandatory=$true, ParameterSetName='ByInnerText')]
    [string]$InnerText,
    # If set, will find elements that have an innertext like the value, rather than an exact match
    [Parameter(ParameterSetName='ByInnerText')]
    [switch]$Like,
    
    # If set, will run a click
    [switch]$Click,
    
    # If provided, will fire a number of javascript events
    [Hashtable]$Event
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'Table') {
            
        } else {
            $originalParameters = @{} + $psBoundParameters
            $null = $psBoundParameters.Remove("Click")
            $null = $psBoundParameters.Remove("Event")
            $null = $psBoundParameters.Remove("Timeout")
            $null = $psBoundParameters.Remove("SleepTime")
            @(Get-BrowserControl @psBoundParameters |
                Select-Object -Unique) | 
                ForEach-Object {
                    if ($click -and $_.Click) {
                        $_.click()
                    }
                    if ($originalParameters['Event'] -and $_.FireEvent) {
                        foreach ($kvp in $originalParameters['Event']) {
                            $_.FireEvent($kvp.Key, $kvp.Value)                            
                        }                        
                    }                    
                }
           
        } 
        $ie |
            Wait-Browser -Timeout $timeout -SleepTime $SleepTime
        
        $ie
    }
}
