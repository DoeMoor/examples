Function send_message_to_slack {
  param (
    $Msg,
    $Emoji
  )

  $var_slack_url='https://hooks.slack.com/services/'
  $var_request_body="payload={`"channel`": `"#`", `"username`": `"webhookbot`", `"text`": `"$Msg`", `"icon_emoji`": `"$Emoji`"}"

  Invoke-WebRequest -Method Post -Uri $var_slack_url -Body $var_request_body
}

function get_request {
  param (
    $url
  )
  
  $file = ($url -split "/").Item(4)
  $out_file = ("L:\$file").ToString()
  
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $out_file
    send_message_to_slack -Msg "file: $file download" -Emoji ":white_check_mark:"
  }
  catch {
    send_message_to_slack -Msg "`[ERROR`] File: $file not download " -Emoji ":X:"
  }

  try {
    copy-Item -Path $out_file -Destination \\x.x.x.x\homes\backup\logs\$file -Passthru
    #send_message_to_slack -Msg " $file copy on \\x.x.x.x\..logs" -Emoji ":white_check_mark:"
  }
  catch {
    send_message_to_slack -Msg "`[ERROR`] File: $file not copy on x.x.x.x " -Emoji ":X:"
  }
  
}


$var_date = (Get-Date).AddDays(-1).ToString('yyyyMMdd')

get_request -url "http://x.x.x.x/logs_serv/appprod-$var_date-log.zip"
get_request -url "http://x.x.x.x/logs_serv/dbprod-$var_date-log.zip"
get_request -url "http://x.x.x.x/logs_serv/webprod-$var_date-log.zip"

get_request -url "http://x.x.x.x/logs_serv/apptest-$var_date-log.zip"
get_request -url "http://x.x.x.x/logs_serv/dbtest-$var_date-log.zip"
get_request -url "http://x.x.x.x/logs_serv/webtest-$var_date-log.zip"