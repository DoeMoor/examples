#Function Get-Test {
#$task = tasklist /fi "imagename eq nginx.exe"
#
#if ($task -imatch 'отсутствуют' ){
#		$task = 'nginx not started!'
#	} else {
#		$task = 'nginx start'
#	}
#
#echo $task
#}
#
# 
#$val=$val.AddDays(-1)


Function sendMessageToSlack {
  param (
    $Msg,
    $Emoji
  )

  $var_slack_url='https://hooks.slack.com/'
  $var_request_body="payload={`"channel`": `"#testchannel`", `"username`": `"webhookbot`", `"text`": `"$Msg`", `"icon_emoji`": `"$Emoji`"}"

  Invoke-WebRequest -Method Post -Uri $var_slack_url -Body $var_request_body
}

#sendMessageToSlack -Msg "test" -Emoji ":X:"

#$data_minus = 0
#
#$data = get-date
#$val=(Get-Date).AddDays(-$data_minus).ToString('yyyyMMdd')

$part_num = 20
$val=(Get-Date).AddDays(-0).ToString('yyyy-MM-dd')
$val
$day = 0

for ($i = 1; $val -ne "2022-03-29"; $i++)
{
    if ($part_num -lt 0){
        
        $val=(Get-Date).AddDays(-$day).ToString('yyyy-MM-dd')
        $day = $day + 1
        $day
        $val
        $part_num = 20
        $part_num
    }
    $part_num
    
    $url = "http://lp/logs/application-$val.$part_num.log.gz"
    $OutFile = "L:\application-$val.$part_num.log.gz"
    $url
    $OutFile

    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    #$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36"
    $session.Cookies.Add((New-Object System.Net.Cookie()))
    Invoke-WebRequest -UseBasicParsing -Uri $url `
        -WebSession $session `
        -OutFile $OutFile ` -WarningAction SilentlyContinue
       
    $part_num = $part_num -1
}










