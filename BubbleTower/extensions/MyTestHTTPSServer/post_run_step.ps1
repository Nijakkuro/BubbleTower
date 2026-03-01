$YYPLATFORM_name = $env:YYPLATFORM_name
$YYoutputFolder = $env:YYoutputFolder
$YYprojectName = $env:YYprojectName
$YYTARGET_runtime = $env:YYTARGET_runtime

$Enable = $env:YYEXTOPT_MyTestHTTPSServer_Enable
$ExePath = $env:YYEXTOPT_MyTestHTTPSServer_ExePath

Write-Host "MyTestHTTPSServer extension post_run_step"

if ($Enable -ne "True") {
	Write-Host "The extension is disabled."
	exit 0
}

Write-Host "Current platform: $YYPLATFORM_name"
Write-Host "Target runtime: $YYTARGET_runtime"

if ($YYPLATFORM_name -ine "Opera GX" -and
	$YYPLATFORM_name -ine "operagx" -and
	$YYPLATFORM_name -ine "HTML5") {
	Write-Host "Aborting: This script is only for Opera GX and HTML5 platform."
	exit 0
}

$rootPath = $YYoutputFolder
if($YYPLATFORM_name -ine "HTML5") {
	$rootPath = [System.IO.Path]::Combine($YYoutputFolder, "runner")
}

Write-Host "Root Path: $rootPath"

$processName = "MyTestHTTPSServer"
$isRunning = [boolean](Get-Process -Name $processName -ErrorAction SilentlyContinue)

if ($isRunning) {
	Write-Host "The process $processName is running."
	
	Write-Host "Changing MyTestHTTPSServer rootPath..."
	
	$uri = "https://localhost:3000/api/config/rootPath"
	$body = @{
		rootPath = $rootPath
	}
	$jsonBody = $body | ConvertTo-Json
	$response = Invoke-RestMethod -Uri $uri -Method Post -Body $jsonBody -ContentType "application/json"
	
	Write-Output $response
	Write-Host "Finished."
} else {
	Write-Host "The process $processName is not running."
	Write-Host "Starting $processName..."
	Start-Process -FilePath "$ExePath" -ArgumentList "--rootPath $rootPath"
	Write-Host "Finished."
}

exit 0