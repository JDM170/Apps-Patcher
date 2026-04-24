# https://github.com/REAndroid/APKEditor
$Parameters = @{
    Uri             = "https://api.github.com/repos/REAndroid/APKEditor/releases/latest"
    UseBasicParsing = $true
    Verbose         = $true
}
$apiResult = Invoke-RestMethod @Parameters
$URL = ($apiResult.assets | Where-Object -FilterScript {$_.content_type -eq "application/x-java-archive"}).browser_download_url
$TAG = $apiResult.tag_name
$Parameters = @{
    Uri             = $URL
    Outfile         = "Morphe\apkeditor.jar"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-RestMethod @Parameters

echo "ApkEditorTag=$TAG" >> $env:GITHUB_OUTPUT
