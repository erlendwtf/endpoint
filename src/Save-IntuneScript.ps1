#Requires -Module Microsoft.Graph.DeviceManagement, Microsoft.PowerShell.ConsoleGuiTools

[cmdletbinding()]
param
(
    [switch]$All,
    [string]$SavePath = $PWD
)

Write-Host "Connecting to Microsoft Graph"
Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All", "DeviceManagementConfiguration.Read.All" -ErrorAction Stop | Out-Null

$scripts = @(Get-MgDeviceManagementScript | ForEach-Object { Get-MgDeviceManagementScript -DeviceManagementScriptId $_.id })

if($scripts.count -eq 0)
{
    Write-Error "No scripts found" -ErrorAction Stop
    return
}

if($scripts.count -gt 1)
{
    if(!$All)
    {
        Write-Host "Found multiple scripts. Save all? Use -All"
        $scripts = $scripts | Where-Object DisplayName -In ($scripts | Select-Object -Property DisplayName,FileName,Description | Out-GridView -Title "Select the scripts you want to download (or use -All to download everything)" -PassThru | Select-Object -ExpandProperty DisplayName)
        if($scripts.count -eq 0)
        {
            Write-Error "You pressed cancel" -ErrorAction Stop
        }
    }
}

Write-Host "Downloading $($scripts.count) script(s)"
foreach($id in $scripts)
{
    $FilePath = $(Join-Path $SavePath $($id.fileName))
    Write-Host "Saving $($id.fileName) to $FilePath"
    [System.Text.Encoding]::ASCII.GetString($id.scriptcontent) | Out-File -Encoding ASCII -FilePath $FilePath
}