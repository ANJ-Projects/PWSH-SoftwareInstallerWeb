


# Set path
Set-Location -Path $PSScriptRoot


# Create script files
foreach ($software in $softwarelist) {


$script = @"
if (Test-Path -Path "$($software.programstartpath)")
{
Start-Process -FilePath "$($software.programstartpath)"
}
else
{
winget install $($software.winget)
Start-Process -FilePath "$($software.programstartpath)"
}
"@