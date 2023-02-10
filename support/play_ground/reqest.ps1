
#$day = 1
$log_name = 'application','camunda'
$yesterday = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
#$day_limit = (Get-Date).AddDays(-2).ToString('yyyy-MM-dd')

foreach($part_path in $log_name) {

    for ($part_num = 50; $part_num -lt 0; $part_num--) {
        
        if ($part_num -lt 0) {
            
            #$yesterday=(Get-Date).AddDays(-$day).ToString('yyyy-MM-dd')
            #$day = $day + 1
            #$part_num = 50
    
        }
        
        $file_name = "$part_path-$yesterday.$part_num.log.gz"
        
        $url = "http://x.x.x.x/logs/2022-04/$file_name"
        $OutFile = "\\x.x.x.x\homes\backup\logs\$part_path`_`part\$file_name"
        $localpath = "L:\$part_path`_`part\$file_name"
    
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $session.Cookies.Add((New-Object System.Net.Cookie()))
        
        try {
    
            Invoke-WebRequest -UseBasicParsing -Uri $url -WebSession $session -OutFile $localpath
            Write-Output "load file: $file_name"
            Copy-Item -Path $localpath -Destination $OutFile -Passthru
        
        } catch {} 
    }    
}





$log_name = 'application','camunda'

foreach($part_name in $log_name){

    $part_num = 50
    $day = 1
    $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyy-MM-dd')
    $day_limit = (Get-Date).AddDays(-3).ToString('yyyy-MM-dd')
  
    for ($i = 0; $cur_date_yesterday -ne $day_limit; $i++) {
  
        if ($part_num -lt 0) {
            
            $day++
            $part_num = 50
            $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyy-MM-dd')
            
        }
        
        $file_name = "$part_name-$cur_date_yesterday.$part_num.log.gz"
  
        $url = "http://x.x.x.x/logs/2022-04/$file_name"
        $OutFile = "\\x.x.x.x\homes\backup\logs\$part_name`_`part"
        $localpath = "L:\$part_name`_`part\$file_name"
    
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $session.Cookies.Add((New-Object System.Net.Cookie()))
        
        try {
  
            Invoke-WebRequest -UseBasicParsing -Uri $url -WebSession $session -OutFile $localpath 
            Write-Output "load file: $file_name"
            Copy-Item -Path $localpath -Destination $OutFile -Passthru
        
        } catch {} 
  
        $part_num = $part_num -1
        Start-Sleep -Milliseconds 600
    }
}




$file_to_load = 'hikari.log','application.txt.log'
$file_app_path = 'hikari','application'
$at = 0

foreach($file_app in $file_to_load) {

    $day = 2
    $cur_date_yesterday = (Get-Date).AddDays(-$day).ToString('yyyyMMdd')
    $day_limit = (Get-Date).AddDays(-15).ToString('yyyyMMdd')




    for ($i = 0; $cur_date_yesterday -ne $day_limit; $i++) {

        $file = $file_app_path.GetValue($at) 

        $file_app_path_url = "http://x.x.x.x/logs/$file_app-$cur_date_yesterday.gz"
        $lockal_app_path = "L:\$file\$file_app-$cur_date_yesterday.gz"
        $rem_path = "\\x.x.x.x\homes\backup\logs\$file"
    
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $session.Cookies.Add((New-Object System.Net.Cookie()))
    
        try {
    
            Invoke-WebRequest -UseBasicParsing -Uri $file_app_path_url -WebSession $session -OutFile $lockal_app_path 
            
            Write-Output "load file: $file_app-$cur_date_yesterday.gz"
            Copy-Item -Path $lockal_app_path -Destination $rem_path -Passthru
        
        } catch {} 
        $day++
    }
    $at++
    
}
