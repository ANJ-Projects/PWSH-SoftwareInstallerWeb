# You Should be able to Copy and Paste this into a powershell terminal and it should just work.
# To end the loop you have to kill the powershell terminal. ctrl-c wont work :/ 

# From https://gist.github.com/jakobii/429dcef1bacacfa1da254a5353bbeac7
# Modified for IP Monitoring Script

# Http Server
$http = [System.Net.HttpListener]::new() 

# Hostname and port to listen on
$WebServerIP = 'http://localhost:8082'
$http.Prefixes.Add("$WebServerIP/")


# Start the Http Server 
$http.Start()

# Dot source IP Monitoring Script
Set-Location -Path $PSScriptRoot
. ".\Add-EditHTML.ps1"
. ".\Add-IPMonitoringHTML.ps1"
. ".\New-PHDashboard.ps1"


# Log ready message to terminal 
if ($http.IsListening) {
    write-host " HTTP Server Ready!  " -f 'black' -b 'gre'
    write-host "try testing the different route examples: " -f 'y'
    write-host "$($http.Prefixes)" -f 'y'
    write-host "$($http.Prefixes)edit" -f 'y'
}


# INFINTE LOOP
# Used to listen for requests
while ($http.IsListening) {



    # Get Request Url
    # When a request is made in a web browser the GetContext() method will return a request object
    # Our route examples below will use the request object properties to decide how to respond
    $context = $http.GetContext()


    # ROUTE VIEW HTML
    # http://127.0.0.1/
    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {

        # We can log the request to the terminal
        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'

        # the html/data you want to send to the browser
        # you could replace this with: [string]$html = Get-Content "C:\some\path\index.html" -Raw
        #[string]$html = "
        #<!DOCTYPE html>
        #<h1>A Powershell Webserver</h1><p>home page</p>"
        Add-IPMonitoringHTML
        [string]$html = Get-Content ".\index.html" -Raw
        
        
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html) # convert htmtl to bytes
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) #stream to broswer
        $context.Response.OutputStream.Close() # close the response
    
    }



    # ROUTE TO EDIT VIA WEB
    # http://localhost:8080/edit'
    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/edit') {

        # We can log the request to the terminal
        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'
        Add-EditHTML
        [string]$html = Get-Content ".\edit.html" -Raw

        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html) 
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) 
        $context.Response.OutputStream.Close()
    }

    # ROUTE Send changes
    if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/send') {

        # decode the form post
        # html form members need 'name' attributes as in the example!
        $FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

        # We can log the request to the terminal
        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'
        Write-Host $FormContent -f 'Green'
        
        # $text = "fullname=Fullnavn&message=Besked"
        $splittext = $FormContent -split {$_ -eq "=" -or $_ -eq "&"}
        $ip = $splittext | Select-Object -Skip 1 -First 1
        $name = $splittext | Select-Object -Skip 3 -First 1
        Write-Host "A server with the $ip and name $name has been added"
        Add-Content -Path ".\servers.txt" -Value "$ip,$name" -Verbose

        Add-EditHTML
        [string]$html = Get-Content ".\edit.html" -Raw

        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }


    
    # ROUTE Clear list
    if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/clear') {

        # decode the form post
        # html form members need 'name' attributes as in the example!
        $FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

        # We can log the request to the terminal
        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'
        Write-Host "User request clearing of servers in the servers.txt list"
        
        Add-EditHTML
        Remove-Item -Path ".\servers.txt" -Force -ErrorAction SilentlyContinue
        # [string]$html = Get-Content ".\edit.html" -Raw
        [string]$html = @"
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta http-equiv="refresh" content="0; url=$WebServerIP/edit">
        </head>
"@
        
        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }




    # powershell will continue looping and listen for new requests...

} 
