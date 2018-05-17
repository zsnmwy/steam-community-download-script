function judge {
    param(
        [string]$Name = $(throw "Parameter missing: -name Name")
    )
    if ($?) {
        Write-Output "成功 $Name"
        Write-Output "              "
    }
    else {
        Write-Output "失败 $Name"
        Write-Output "    " "搞不定就来github提issue" "https://github.com/zsnmwy/max-translation-update-script"
        Pause
        exit
    }
}

Write-Output "              " "Author zsnmwy" "Github https://github.com/zsnmwy/steam-community-download-script" "               "


[int]$community_id = Read-Host "请输入创意工坊的ID"
if ($?) {
    
}
else {
    Write-Output "请输入一个数字"
    exit
}


$api_url = "http://steamworkshopdownloader.com/api/workshop/$community_id"

Write-Output $api_url
#$ErrorActionPreference = "SilentlyContinue"
#$ErrorActionPreference = "Continue"
#http://steamworkshopdownloader.com/api/workshop/1383841968
try {
    $result = Invoke-WebRequest $api_url
}
catch {
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Output "    " "    " "    "
    $responseBody | ConvertFrom-Json | Select-Object -ExpandProperty message
    Write-Output "    " "    " "    "
    exit
}
$data = Invoke-WebRequest $api_url
judge -Name "请求Workshop API"
$decode = ConvertFrom-Json $data.content
$file_url = $decode.file_url
judge -Name "解析file—url"
Write-Output $file_url
$headRequest = Invoke-WebRequest $file_url -Method Head
judge -Name "获取文件头"
$file_name = $headRequest.Headers['Content-Disposition'].Split("';", [System.StringSplitOptions]::RemoveEmptyEntries) | Select-Object -Last 1
$date = Get-Date -Format MMddHHmm
$file_name = "$date $file_name"
Invoke-WebRequest $file_url -OutFile "$pwd\$file_name"
judge -Name "下载文件"