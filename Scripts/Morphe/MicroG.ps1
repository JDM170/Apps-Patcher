# https://github.com/MorpheApp/MicroG-RE
$Parameters = @{
    Uri             = "https://api.github.com/repos/MorpheApp/MicroG-RE/releases/latest"
    UseBasicParsing = $true
    Verbose         = $true
    Headers         = @{
        Authorization = "token $env:GITHUB_TOKEN"
    }
}
$apiResult = Invoke-RestMethod @Parameters
$TAG = $apiResult.tag_name
$URL = ($apiResult.assets | Where-Object -FilterScript {$_.name -eq "microg-$TAG.apk"}).browser_download_url
$Parameters = @{
    Uri             = $URL
    Outfile         = "Morphe\microg.apk"
    UseBasicParsing = $true
    Verbose         = $true
    Headers         = @{
        Authorization = "token $env:GITHUB_TOKEN"
    }
}
Invoke-RestMethod @Parameters

echo "MicroGTag=$TAG" >> $env:GITHUB_OUTPUT
