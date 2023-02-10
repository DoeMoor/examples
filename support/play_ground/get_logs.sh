#!/bin/bash

getFile() {

   result_unzip=$(unzip -j -o "$1" "$2" -d "$3")
   echo "result_unzip = unzip -j -o $1 $2 -d $3"
   result_unzip=$(unzip -j -o "$1" "$4" -d "$5")
   echo "result_unzip = unzip -j -o $1 $4 -d $5"

   if [ $? -eq 0 ]; then
      echo "unZip ok"
      #transferToArchive $1
   else
      echo "unZip faild"
   fi

   if [ "$2" = "$web_log" ]; then
      echo "web_log? = $2"
      gZip_result=$(gzip -d -f /var/*paths*.gz)
      echo "$gZip_result"
      gZip_result=$(gzip -d -f /var/*paths*.gz)
      echo "$gZip_result"
      if [ $? -eq 0 ]; then
         echo "unpacked .gz"
      else
         echo ".gz not unpacked"
      fi
   else
      echo "not web"
   fi
}

transferToArchive() {
   mv "$1" /mnt/log/archive/
   if [ $? == 0 ]; then
      echo "log $1 move to archive"
   else
      echo "ERROR: log not move to archive"
   fi
}

#var_date=$(date --date="yesterday" +"%Y%m%d")
app_log="*application* *browser-requests* *browser-responses* *request-performance* *hikari* *camunda*"
db_log="*slow-query* *mysqld*"
web_log="*access* *error*"

ever_log="*cron* *messages* *secure* *yum* *maillog*"

getFile *paths*-*-log.zip "$web_log" *paths* "$ever_log" *paths*
getFile *paths*-*-log.zip "$db_log" *paths* "$ever_log" *paths*
getFile *paths*-*-log.zip "$app_log" *paths* "$ever_log" *paths*