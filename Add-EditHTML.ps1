

# https://ej2.syncfusion.com/documentation/listview/how-to/add-and-remove-list-items-from-listview/
# https://www.w3schools.com/css/css_table_size.asp
# https://www.w3schools.com/css/tryit.asp?filename=trycss_form_responsive


Function Add-EditHTML {

### HTML Form
$form = @"
<!DOCTYPE html>
<html>
<head>
<style>
* {
  box-sizing: border-box;
}

input[type=text], select, textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  resize: vertical;
}

label {
  padding: 12px 12px 12px 0;
  display: inline-block;
}

input[type=submit] {
  background-color: #0066ff;
  color: white;
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  float: right;
}

input[type=submit]:hover {
  background-color: #45a049;
}

.container {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}

.col-25 {
  float: left;
  width: 25%;
  margin-top: 6px;
}

.col-75 {
  float: left;
  width: 75%;
  margin-top: 6px;
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

/* Responsive layout - when the screen is less than 600px wide, make the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 600px) {
  .col-25, .col-75, input[type=submit] {
    width: 100%;
    margin-top: 0;
  }
}
</style>
</head>
<body>

<h1>Add new Software</h1>

<div class="container">
  <form action='/send' method='post'>
  <div class="row">
    <div class="col-25">
      <label for="ip">IP</label>
    </div>
    <div class="col-75">
      <input type="text" id="ip" name="ip" placeholder="Enter the IP of the server..">
    </div>
  </div>
  <div class="row">
    <div class="col-25">
      <label for="name">Name</label>
    </div>
    <div class="col-75">
      <input type="text" id="name" name="name" placeholder="Enter the name of the software..">
    </div>
  </div>
  <div class="row">
    <div class="col-25">
    </div>
  </div>
  <div class="row">

  </div>
  <br>
  <div class="row">
    <input type="submit" value="Submit">
  </div>
  </form>
</div>

</body>
</html>
"@

### List servers in html

$content = @"
<!DOCTYPE html>
<html>
<head>
<style>
#softwaretable {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#softwaretable td, #softwaretable th {
  border: 1px solid #ddd;
  padding: 8px;
}

#softwaretable tr:nth-child(even){background-color: #f2f2f2;}

#softwaretable tr:hover {background-color: #ddd;}

#softwaretable th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #0066ff;
  color: white;
}
</style>
</head>
<body>

<h1>Software</h1>

<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for software.." title="Type in a software">

<table id='softwaretable'>
  <tr>
    <th>Name</th>
    <th>Winget Name</th>
    <th>Program Path</th>
    <th>Start buttom</th>
  </tr>

<script>
function myFunction() {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("softwaretable");
  tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[0];
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }       
  }
}
</script>



"@

$htmltable = @"
</table>

  </div>
  <form action='/clear' method='post'>
  <br>
  <div class="row">
  <input type="submit" value="Clear Software">
  </form>      
  </div>

</body>
</html>
"@

New-Item -Path ".\edit.html" -ItemType File -Value $form -Force
Add-Content -Path ".\edit.html" -Value $content -Force

If (Test-Path -Path ".\softwarelist.csv") {
$softwarelist = Get-content ".\softwarelist.csv" | ConvertFrom-Csv -Delimiter ','
}
Else
{ 
Write-Host 'Software text file named softwarelist.csv not found. Creating file... -f Red'
New-Item -ItemType File -Path ".\softwarelist.csv" -Value "Name,winget,programstartpath`r`n"
}


foreach ($software in $softwarelist){
    Add-Content -Value "  <tr>" -LiteralPath .\edit.html -Force
    Add-Content -Value "<td>$($software.Name)</td>" -LiteralPath .\edit.html -Force
    Add-Content -Value "<td>$($software.winget)</td>" -LiteralPath .\edit.html -Force
    Add-Content -Value "<td>$($software.programstartpath)</td>" -LiteralPath .\edit.html -Force
    Add-Content -Value "<td><button type='button' onclick='fetch($($software.'StartLink'));'>Start $($software.Name)</button></td>"  -LiteralPath .\edit.html -Force
    
    
    Add-Content -Value "  </tr>" -LiteralPath .\edit.html -Force    
}

Add-Content -Value $htmltable -LiteralPath .\edit.html -Force
}

#    <button type="button" onclick="fetch('https://api.simplepush.io/send/ijSotE/SubjectHere/TextHere');">Buttom</button>
#    <form action='/clear' id="ClearServers" method='post'>
#    <input type='reset' and add onclick='document.forms["ClearServers"].submit();'>