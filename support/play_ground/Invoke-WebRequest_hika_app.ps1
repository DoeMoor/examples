$file_to_load = 'hikari.log','application.txt.log'
$file_app_path = 'hikari','application_txt'
$at = 0

foreach($file_app in $file_to_load) {

    $day = 2
    $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyyMMdd')
    $day_limit = (Get-Date).AddDays(-9).ToString('yyyyMMdd')




    for ($i = 0; $cur_date_yesterday -ne $day_limit; $i++) {

        $file = $file_app_path.GetValue($at) 

        $file_app_path_url = "http://ip/logs/$file_app-$cur_date_yesterday.gz"
        $lockal_app_path = "L:\logs-archive\$file\$file_app-$cur_date_yesterday.gz"
        $rem_path = "\\ip\homes\backup\logs\\$file\"
    
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $session.Cookies.Add((New-Object System.Net.Cookie()))
    
            Invoke-WebRequest -UseBasicParsing -Uri $file_app_path_url -WebSession $session -OutFile $lockal_app_path 
            
            Write-Output "load file: $file_app-$cur_date_yesterday.gz"
            Copy-Item -Path $lockal_app_path -Destination $rem_path -Passthru
        
        
        $day++
        $day
        $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyyMMdd')
        
    }

    $at++
    
}
