#!/bin/bash

sendMessageToSlack() {
    var_slack_url="https://hooks.slack.com/services/"
    var_request_body="payload={\"channel\": \"#channel\", \"username\": \"webhookbot\", \"text\": \"$1\", \"icon_emoji\": \"$2\"}"
    curl --silent --request POST --data-urlencode "$var_request_body" $var_slack_url
}
# sendMessageToSlack - Отправка сообщения в слак, канал #channel
# $1 - Текст сообщения
# $2 - Эмоджи на эконку сообщения

path_enable="*paths*" # поле для проверки наличия подключённого диска 
dateSh=$(date)
dateSh="START \n$dateSh"
echo -e "$dateSh" | tee -a *paths*
logArchive=$(ls -c *paths* | grep prod | head -1) # Получаем название архива
log=" File: $logArchive,"


# Эти перечисления сразу все возможные файлики, для распределения по папкам при копировании.
# как пример: файлы из "app_log" попадут в папку "*paths*" а папки "ever_log" в "*paths*"
# это необходимо для анализа логов, так как, конфиги логстеша настроены на папки а не на конкретные файлики. 
app_log="*application* *browser-requests* *browser-responses* *request-performance* *hikari* *camunda* *catalina*"
 # Перечисление логов приложения 
db_log="*slow-query* *mysqld*"
 # Перечисление логов MySQL
web_log="*access* *error*"
 # Перечисление логов web
ever_log="*cron* *messages* *secure* *yum* *maillog*"
 # Перечисление логов Сервера

if ! [[ -d "$path_enable" ]]; then # Проверили наличие пути
    sendMessageToSlack "У сервера ELK нет доступа к директории *paths* !" ":X:"
    dateSh=$(date)
    log="У ELK нет доступа к директории !\n$dateSh\nEND"
    echo -e "$log" | tee -a /var/log/xxxx
    exit
fi

transferToArchive() { # Перемещаем архивы в папку с архивами
    if [[ "$logArchive" == *"m"* ]]; then
        mv /mnt/log/"$1" *paths* | tee -a /var/log/xxxx # Перемещаем архивы в папку с архивами
        if [ $? == 0 ]; then
            log="$log log $1 move to archive"
        else
            log="$log ERROR: log $1 not move to archive"
        fi
    else
        echo "Nothing move: $1" | tee -a /var/log/xxxx
    fi

}

unzipArchive() { # Распаковка сжатых логов
    echo "unzip -j -o  /mnt/log/$1 $2 -d $3"
    unzip -j -o /mnt/log/"$1" "$2" -d "$3" | tee -a /var/log/xxxx # Распаковали архивы 
    log="$log unzip result $?,"

    if [ "$2" = "$web_log" ]; then
        echo "gzip -d -f $3access*.gz"

        gZip_result=$(gzip -d -f "$3"access*.gz) # Распаковка сжатых логов
        echo "$gZip_result"

        gZip_result=$(gzip -d -f "$3"error*.gz) # Распаковка сжатых логов
        echo "gzip -d -f $3error*.gz"

        if [ $? -eq 0 ]; then
            echo "unpacked .gz"
        else
            echo ".gz not unpacked"
        fi
    else
        echo "not web"
    fi

}

if [[ "$logArchive" == *"prod"* ]]; then # Основной скрипт распаковки логов сервера продуктива, по папкам, в зависимости от источника архива.

    if [[ "$logArchive" == *"web"* ]]; then
        unzipArchive "$logArchive" "$web_log" /var/web/nginx/
        unzipArchive "$logArchive" "$ever_log" /var/web/
        sendMessageToSlack "Архив логов $logArchive загружен в ELK" ":white_check_mark:"
        transferToArchive "$logArchive"

    elif [[ "$logArchive" == *"db"* ]]; then
        unzipArchive "$logArchive" "$db_log" /var/mysql/
        unzipArchive "$logArchive" "$ever_log" /var/db/
        sendMessageToSlack "Архив логов $logArchive загружен в ELK" ":white_check_mark:"
        transferToArchive "$logArchive"

    elif [[ "$logArchive" == *"app"* ]]; then
        unzipArchive "$logArchive" "$app_log" /var/
        unzipArchive "$logArchive" "$ever_log" /var/app2/
        sendMessageToSlack "Архив логов $logArchive загружен в ELK " ":white_check_mark:"
        transferToArchive "$logArchive"

    else
        log="$log not recognized in line 100 file:$logArchive,"

    fi

elif [[ "$logArchive" == *"test15"* ]]; then # не реализованный скрипт для тест сервера.

    if [[ "$logArchive" == *"web"* ]]; then
        unzipArchive "$logArchive" "$web_log" /var/nginx/
        unzipArchive "$logArchive" "$ever_log" /var/
        transferToArchive "$logArchive"

    elif [[ "$logArchive" == *"db"* ]]; then
        unzipArchive "$logArchive" "$db_log" /var/mysql/
        unzipArchive "$logArchive" "$ever_log" /var/db/
        transferToArchive "$logArchive"

    elif [[ "$logArchive" == *"app"* ]]; then
        unzipArchive "$logArchive" "$app_log" /var/
        unzipArchive "$logArchive" "$ever_log" /var/
        transferToArchive "$logArchive"

    else
        log="$log not recognized in line 122 $logArchive,"

    fi

else
    log="$log not recognized in line 127 $logArchive,"

fi

echo "$log" | tee -a /var/log/xxxx

dateSh=$(date)

log="$dateSh\nEND"
echo -e "$log" | tee -a /var/log/xxxx