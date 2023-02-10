$log_name = 'application','camunda'

foreach($part_name in $log_name){

    $part_num = 50
    $day = 12
    $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyy-MM-dd')
    $day_limit = (Get-Date).AddDays(-70).ToString('yyyy-MM-dd')
  
    for ($i = 0; $cur_date_yesterday -ne $day_limit; $i++) {
  
        if ($part_num -lt 0) {
            
            $day++
            $part_num = 50
            $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyy-MM-dd')
            
        }
        
        $file_name = "$part_name-$cur_date_yesterday.$part_num.log.gz"
  
        $url = "http://ip/logs/$file_name"
        $OutFile = "\\ip\homes\backup\logs-archive\$part_name`_`part"
        $localpath = "L:\logs-archive\$part_name`_`part\$file_name"
    
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $session.Cookies.Add((New-Object System.Net.Cookie()))
        
        try {
  
            Invoke-WebRequest -UseBasicParsing -Uri $url -WebSession $session -OutFile $localpath 
            Write-Output "load file: $file_name"
            Copy-Item -Path $localpath -Destination $OutFile -Passthru
            Write-Output "copy file: $file_name"
            Start-Sleep -Milliseconds 600
        
        } catch {} 
  
        $part_num = $part_num -1
        
    
    }
}
