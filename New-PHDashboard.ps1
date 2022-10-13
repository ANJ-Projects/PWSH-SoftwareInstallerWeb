    <#
        .SYNOPSIS
        Creates a dashboard via a HTML file

        .DESCRIPTION
        This script creates a dashboard via a HTML file that can then be run using a webserver opened directly in the browser
        This has been modified for IP Monitoring Dashboard

        .PARAMETER Name
        Specifies the file name.
        
        .PARAMETER BackgroundStyle
        Blue #0066ff, Red #ff5050

        .EXAMPLE
        NewHTML-Dashboard -TabTitle "Stuff" -Title "Stuff here" -MiniTitle "Stuff site" -Body "Welcome"

        .EXAMPLE
        New-PHDashboard -TabTitle "Stuff" -BackgroundStyle Blue -Title "Titlestuff" -BodyTitle "InformationHere" -MiniTitle "Underinformation" -html_path "./"

        .LINK
        Online version: github

    #>
    function New-PHDashboard {
        param (
            [Parameter (Mandatory = $false)] [String]$TabTitle='TabTitleHere',
            [Parameter (Mandatory = $false)] [String]$Title='TitleHere',
            [Parameter (Mandatory = $false)] [String]$MiniTitle='MiniTitleHere',
            [Parameter (Mandatory = $false)] [String]$BodyTitle='BodyTitleHere',
            [Parameter (Mandatory = $false)] [String]$html_path='./index.html',
            [Parameter(Mandatory=$false)] [ValidateSet('Yes','No')] [String[]]$CenterBodyTitle='No',
            [Parameter(Mandatory=$false)] [ValidateSet('Blue','Green','Red','Orange','Purple','Yellow','Brown','Grey','Teal')] [String[]]$BackgroundStyle='Blue'
        )
    
    # Makes stuff with different langauges work
    $PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Removes the file if found
if (test-path -path $html_path)
{
Remove-Item -Path $html_path -Force -ErrorAction SilentlyContinue
}
else
{
Write-Host "Index file not found... creating file"
}

Switch ( $BackgroundStyle ) {
    Blue {$Background = "#0066ff"}
    Green {$Background = "#33ff33"}
    Red {$Background = "#ff5050"}
    Orange {$Background = "#ff5050"}
    Purple {$Background = "#993399"}
    Yellow {$Background = "#e6e600"}
    Brown {$Background = "#996633"}
    Grey {$Background = "#a6a6a6"}
    Teal {$Background = "#99ffcc"}
}

    If ($CenterBodyTitle -eq 'Yes') {
       $Center = '<Center>' 
       }

# HTML
$HTML = @"
<!DOCTYPE html>
<html lang="en">
<head>
<title>$TabTitle</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
/* Style the body */
body {
  font-family: Arial;
  margin: 0;
}
/* Header/Logo Title */
.header {
  padding: 60px;
  text-align: center;
  background: $Background;
  color: white;
  font-size: 30px;
}
/* Page Content */
.content {padding:20px;}
</style>
</head>
<body>
<div class="header">
  <h1>$Title</h1>
  <p>$MiniTitle</p>
</div>
<div class="content">
  $Center<h1>$BodyTitle</h1>
"@

    #Creates html file from content above 
    Add-Content -Value $HTML -Path $html_path -Force

    }
