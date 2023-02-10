$taskIDPart_1 = 8998787454,64654787,465464678,46467894,45464,78741451
$taskIDPart_2 = 
$taskIDPart_3 = 

foreach ($id in $taskIDPart_1){

    $url = "http://ip/requests/$id"
    
    Start-Sleep -Seconds 2

    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.UserAgent = ""
    $session.Cookies.Add((New-Object System.Net.Cookie()))
    $resp = Invoke-WebRequest -UseBasicParsing -Uri $url `
    -WebSession $session `
    -Headers @{
    "Pragma"="no-cache"
      "Cache-Control"="no-cache"
      "Accept"="application/json"
      "Referer"="http://ip/"
      "Accept-Encoding"="gzip, deflate"
      "Accept-Language"="ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
    } `
    -ContentType "application/json"

    $procId = $resp.Content | ConvertFrom-Json | Select-Object -Property processId

    if ($null -eq $procId.processId){ $id }

}