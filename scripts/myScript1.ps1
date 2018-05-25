<#
    .SYNOPSIS
        This Script runs on master head node start, it is used in the ARM template to pass around the storage account name, key
        as well as the mpsEndpoint. It saves the result to local disk and restarts the main nodeJS dashboard process running on the VM
#>

Param (
    [String]$storageAccountName,
    [String]$storageAccountKey,
    [String]$dbConnectionString,
    [String]$mpsEndPoint
)

$myObj = New-Object System.Object

$myObj | Add-Member -type NoteProperty -name storageAccountName -value $storageAccountName
$myObj | Add-Member -type NoteProperty -name storageAccountKey -value $storageAccountKey
$myObj | Add-Member -type NoteProperty -name dbConnectionString -value $dbConnectionString
$myObj | Add-Member -type NoteProperty -name mpsEndPoint -value $mpsEndPoint

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

$myContent = $myObj | ConvertTo-Json -Depth 100 
$myPath = "c:\\MathWorks\\controllerServer\\dynamicOptions.json"
[System.IO.File]::WriteAllLines($myPath, $myContent, $Utf8NoBomEncoding)

# Out-File "c:\\MathWorks\\controllerServer\\dynamicOptions.json" -Encoding UTF8


# restart the main process
net stop controllerServer5.exe
echo "Stopped the process successfully"
net start controllerServer5.exe
echo "Started the process successfully"