$file = ls \\ip\homes\backup\logs\*prod* -Name
$destpath = "\\ip\homes\backup\logs\"

foreach($name in $file){

  copy-Item -Path \\ip\homes\backup\logs\$name -Destination $destpath -Passthru -ErrorAction Stop

}

