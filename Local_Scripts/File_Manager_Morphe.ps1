<#
    .SYNOPSIS
    Build Morphe app using latest components:
      * File Manager (latest supported);
      * Morphe Desktop (CLI);
      * Morphe Patches;
      * Azul Zulu.

    .NOTES
    After compiling reddit-morphe.apk will be located in "Script location folder\FileManager-Morphe"

    .LINKS
    https://github.com/MorpheApp
#>

# Requires -Version 5.1
# Doesn't work on PowerShell 7.2 due it doesn't contains IE parser engine. You have to use a 3rd party module to make it work like it's presented in CI/CD config: AngleSharp

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ($Host.Version.Major -eq 5)
{
    # Progress bar can significantly impact cmdlet performance
    # https://github.com/PowerShell/PowerShell/issues/2138
    $Script:ProgressPreference = "SilentlyContinue"
}

# Download all files to "Script location folder\FileManager-Morphe"
$CurrentFolder = Split-Path $MyInvocation.MyCommand.Path -Parent
if (-not (Test-Path -Path "$CurrentFolder\FileManager-Morphe"))
{
    New-Item -Path "$CurrentFolder\FileManager-Morphe" -ItemType Directory -Force
}

Write-Host "" -ForegroundColor Green
Write-Host "Downloading Morphe CLI" -ForegroundColor Green
# https://github.com/MorpheApp/morphe-cli
$Parameters = @{
    Uri             = "https://api.github.com/repos/MorpheApp/morphe-desktop/releases/latest"
    UseBasicParsing = $true
    Verbose         = $true
}
$URL = ((Invoke-RestMethod @Parameters).assets | Where-Object -FilterScript {$_.content_type -eq "application/java-archive"}).browser_download_url | Select-Object -First 1
$Parameters = @{
    Uri             = $URL
    Outfile         = "$CurrentFolder\FileManager-Morphe\morphe-cli.jar"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-RestMethod @Parameters

Write-Host "" -ForegroundColor Green
Write-Host "Downloading Morphe patches" -ForegroundColor Green
# https://github.com/MorpheApp/morphe-patches
$Parameters = @{
    Uri             = "https://api.github.com/repos/dieroboter/morphe-patches/releases/latest"
    UseBasicParsing = $true
    Verbose         = $true
}
$URL = ((Invoke-RestMethod @Parameters).assets | Where-Object -FilterScript {$_.content_type -eq "application/dash-patch+xml"}).browser_download_url
$Parameters = @{
    Uri             = $URL
    Outfile         = "$CurrentFolder\FileManager-Morphe\morphe-patches.mpp"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-RestMethod @Parameters

# Sometimes older version of zulu-jdk causes conflict, so remove older version before proceeding.
if (Test-Path -Path "$CurrentFolder\FileManager-Morphe\jdk")
{
    Remove-Item -Path "$CurrentFolder\FileManager-Morphe\jdk" -Recurse -Force
}

Write-Host "" -ForegroundColor Green
Write-Host "Downloading Azul Zulu" -ForegroundColor Green
# https://github.com/ScoopInstaller/Java/blob/master/bucket/zulu-jdk.json
$Parameters = @{
    Uri             = "https://raw.githubusercontent.com/ScoopInstaller/Java/master/bucket/zulu-jdk.json"
    UseBasicParsing = $true
    Verbose         = $true
}
$URL = (Invoke-RestMethod @Parameters).architecture."64bit".url
$Parameters = @{
    Uri             = $URL
    Outfile         = "$CurrentFolder\FileManager-Morphe\jdk_windows-x64_bin.zip"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-RestMethod @Parameters

# Expand jdk_windows-x64_bin archive
$Parameters = @{
    Path            = "$CurrentFolder\FileManager-Morphe\jdk_windows-x64_bin.zip"
    DestinationPath = "$CurrentFolder\FileManager-Morphe\jdk"
    Force           = $true
    Verbose         = $true
}
Expand-Archive @Parameters

Remove-Item -Path "$CurrentFolder\FileManager-Morphe\jdk_windows-x64_bin.zip" -Force

# Find latest supported File Manager Plus APK version
Write-Host "" -ForegroundColor Green
Write-Host "Getting latest supported File Manager Plus APK version" -ForegroundColor Green
$patches_list = & "$CurrentFolder\FileManager-Morphe\jdk\zulu*win_x64\bin\java.exe" `
-jar "$CurrentFolder\FileManager-Morphe\morphe-cli.jar" list-patches `
--patches "$CurrentFolder\FileManager-Morphe\morphe-patches.mpp" `
--with-descriptions `
--with-packages `
--with-versions `
-f "com.alphainventor.filemanager"
$LatestSupported = [regex]::Matches($patches_list, "\d{1}\.\d{1}.\d{1}") | ForEach-Object { $_.Value } | Sort-Object -Descending -Unique | Select-Object -First 1

Write-Host "" -ForegroundColor Green
Write-Host "Download File Manager Plus $LatestSupported" -ForegroundColor Green
Write-Host "Place the file in the 'Morphe' folder with the name 'fmp.apk'." -ForegroundColor Green
Write-Host "Press Enter to continue." -ForegroundColor Green
Read-Host

# Let's create patched APK
Write-Host "" -ForegroundColor Green
Write-Host "Creating patched APK" -ForegroundColor Green
& "$CurrentFolder\FileManager-Morphe\jdk\zulu*win_x64\bin\java.exe" `
-jar "$CurrentFolder\FileManager-Morphe\morphe-cli.jar" patch `
--patches "$CurrentFolder\FileManager-Morphe\morphe-patches.mpp" `
--temporary-files-path "$CurrentFolder\FileManager-Morphe\Temp" `
--out "$CurrentFolder\FileManager-Morphe\fmp-morphe.apk" `
"$CurrentFolder\FileManager-Morphe\fmp.apk"

# Open working directory with builded files
# Invoke-Item -Path "$CurrentFolder\FileManager-Morphe"

$Files = @(
    "$CurrentFolder\FileManager-Morphe\Temp",
    "$CurrentFolder\FileManager-Morphe\jdk",
    "$CurrentFolder\FileManager-Morphe\morphe-cli.jar",
    "$CurrentFolder\FileManager-Morphe\morphe-patches.mpp",
    "$CurrentFolder\FileManager-Morphe\fmp.apk"
)
Remove-Item -Path $Files -Recurse -Force

Write-Warning -Message "Latest available fmp-morphe.apk are ready in `"$CurrentFolder\FileManager-Morphe`""
