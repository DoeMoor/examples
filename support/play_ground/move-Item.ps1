

$namemass = 'apptest', 'dbtest', 'webtest'
$yearmass ='2021', '2020','2019','2018','2017'


foreach($name1 in $namemass){

  foreach($year1 in $yearmass){
  
    $file = ls \\ip\homes\backup\logs\logs-archive\test\*$name1-$year1* -Name

    $destpath = "\\ip\homes\backup\logs\logs-archive\test\$year1"

    foreach($filename in $file){

      move-Item -Path \\ip\homes\backup\logs\archive\test\$filename -Destination $destpath -Passthru -ErrorAction Stop -Force

    }
  }
}
#'app01', 'db01', 'web01', 'webprod', 'dbprod', 'appprod', 'app02', 'db02', 'web02','app01'
#'apptest', 'dbtest', 'webtest'