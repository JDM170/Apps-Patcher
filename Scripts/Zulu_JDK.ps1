# https://github.com/ScoopInstaller/Java/blob/master/bucket/zulu-jdk.json
$Parameters = @{
    Uri             = "https://raw.githubusercontent.com/ScoopInstaller/Java/master/bucket/zulu-jdk.json"
    UseBasicParsing = $true
    Verbose         = $true
    Headers         = @{
        Authorization = "token $env:GITHUB_TOKEN"
    }
}
$apiResult = Invoke-RestMethod @Parameters
$URL = $apiResult.architecture."64bit".url
$TAG = $apiResult.version
$Parameters = @{
    Uri             = $URL
    Outfile         = "$env:ZuluJDKDir\jdk_windows-x64_bin.zip"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-RestMethod @Parameters

echo "ZuluTag=$TAG" >> $env:GITHUB_OUTPUT

Write-Verbose -Message "Expanding Zulu JDK" -Verbose

$Parameters = @{
    Path            = "$env:ZuluJDKDir\jdk_windows-x64_bin.zip"
    DestinationPath = "$env:ZuluJDKDir\jdk_windows-x64_bin"
    Force           = $true
    Verbose         = $true
}
Expand-Archive @Parameters

Remove-Item -Path "$env:ZuluJDKDir\jdk_windows-x64_bin.zip" -Force
